require 'faye/websocket'
require 'rack'
require 'thin'

module Dealer
  class Server
    def initialize(game, port)
      @game = game
      @port = port
      @emitters = {}
    end

    def start
      @ws_thread = Thread.new do
        Faye::WebSocket.load_adapter('thin')
        Rack::Handler.get('thin').run(rack_app, Port: @port)
      end
      self
    end

    def stop
      @ws_thread.kill
      self
    end

    private

    def rack_app
      lambda do |env|
        if Faye::WebSocket.websocket?(env)
          ws = Faye::WebSocket.new(env)
          player = @game.register_connection do |message, data|
            ws.send({ 'name' => message, 'data' => data }.to_json)
          end

          ws.on :message do |event|
            message = JSON.parse(event.data)

            begin
              @game.public_send("player_#{message['name']}", player, message['data'])
              @game.notify_state
            rescue
              puts $ERROR_INFO
              puts $ERROR_INFO.backtrace
            end
          end

          ws.on :close do
            @game.remove_player(player)
          end

          ws.rack_response
        else
          [200, { 'Content-Type' => 'text/plain' }, ["Dealer #{Dealer::VERSION}"]]
        end
      end
    end
  end
end
