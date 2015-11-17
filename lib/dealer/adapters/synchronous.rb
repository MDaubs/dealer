module Dealer
  module Adapters
    module Synchronous
      class ClientAdapter
        def initialize(server_adapter, &client_receiver)
          @connection = server_adapter.new_connection(&client_receiver)
        end

        def <<(message_from_client)
          @connection.send_to_server(message_from_client)
          self
        end
      end

      class ServerAdapter
        def initialize
          @connections = []
          @connect_handlers = []
          @message_handlers = []
        end

        def on_message(&handler)
          @message_handlers << handler
          self
        end

        def on_connect(&handler)
          @connect_handlers << handler
          self
        end

        def new_connection(&client_receiver)
          Connection.new(@message_handlers, &client_receiver).tap do |cc|
            @connections << cc
            @connect_handlers.each { |handler| handler.call(cc) }
          end
        end

        class Connection
          def initialize(server_receivers, &client_receiver)
            @server_receivers = server_receivers
            @client_receiver = client_receiver
          end

          def send_to_server(message)
            @server_receivers.each do |message_handler|
              message_handler.call(self, message)
            end
            self
          end

          def send_to_client(message)
            @client_receiver.call(message)
            self
          end
        end
      end
    end
  end
end
