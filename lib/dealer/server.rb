module Dealer
  class Server
    def initialize(game, adapter)
      player_by_connection = {}

      adapter.on_connect do |connection|
        player_by_connection[connection] = game.register_connection do |message, data|
          connection.send_to_client({ name: message, data: data }.to_json)
        end
      end

      adapter.on_message do |connection, message|
        message = JSON.parse(message)
        game.public_send("player_#{message['name']}", player_by_connection[connection], message['data'])
        game.notify_state
      end
    end
  end
end
