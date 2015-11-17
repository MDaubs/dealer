require 'faye/websocket'
require 'rack'
require 'thin'

module Dealer
  module Adapters
    module WebSocket
      class ClientAdapter
        def initialize(uri, &client_receiver)
          @ws_client = Faye::WebSocket::Client.new(uri)

          @ws_client.on :message do |event|
            client_receiver.call(event.data)
          end
        end

        def <<(message_from_client)
          @ws_client.send(message_from_client)
          self
        end
      end

      class ServerAdapter
        def initialize(port)
          @connections = []
          @connect_handlers = []
          @message_handlers = []
          @ws_thread = Thread.new do
            Faye::WebSocket.load_adapter('thin')
            Rack::Handler.get('thin').run(rack_app, Port: port)
          end
        end

        def stop
          @ws_thread.kill
          self
        end

        def on_message(&handler)
          @message_handlers << handler
          self
        end

        def on_connect(&handler)
          @connect_handlers << handler
          self
        end

        private

        class Connection
          def initialize(socket)
            @socket = socket
          end

          def send_to_client(message)
            @socket.send(message)
          end
        end

        def rack_app
          lambda do |env|
            if Faye::WebSocket.websocket?(env)
              ws = Faye::WebSocket.new(env)
              cc = Connection.new(ws)

              ws.on :open do
                @connect_handlers.each { |handler| handler.call(cc) }
              end

              ws.on :message do |event|
                message = JSON.parse(event.data)
                @message_handlers.each { |handler| handler.call(cc, message) }
              end

              ws.rack_response
            else
              [200, { 'Content-Type' => 'text/plain' }, ["Dealer #{Dealer::VERSION}"]]
            end
          end
        end
      end
    end
  end
end
