require 'faye/websocket'

module Dealer
  class Client
    def initialize(uri)
      @cards_at_location = {}
      @ws_client = Faye::WebSocket::Client.new(uri)

      @ws_client.on :message do |event|
        msg, *args = event.data.split(':')

        case msg
        when 'player_id'
          @player_id = args.first
        when 'card_location_state'
          id, cards = args
          @cards_at_location[id] = cards
        end
      end
    end

    def take_action(action_name, *args)
      @ws_client.send([action_name, *args].join(':'))
      self
    end

    def game_state
      "My Hand: #{@cards_at_location["player/#{@player_id}/hand"]}"
    end
  end
end
