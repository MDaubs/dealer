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
          player = @game.register_connection { |msg, *args| ws.send([msg, *args].join(':')) }

          ws.on :message do |event|
            msg, *args = event.data.split(':')

            begin
              @game.public_send("player_#{msg}", player, *args)
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
