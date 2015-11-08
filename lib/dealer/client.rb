require 'faye/websocket'

module Dealer
  class Client
    attr_reader :player_id

    def initialize(uri)
      @cards_at_location = {}
      @game_state = {}
      @ws_client = Faye::WebSocket::Client.new(uri)

      @ws_client.on :message do |event|
        msg, *args = event.data.split(':')

        case msg
        when 'player_id'
          @player_id = args.first
        when 'card_location_state'
          id, cards = args
          @cards_at_location[id] = cards
          @game_state[:card_locations] ||= []
          existing_game_state_card_location = @game_state[:card_locations].find { |l| l[:id] == id }
          if existing_game_state_card_location
            existing_game_state_card_location[:cards] = cards
          else
            @game_state[:card_locations] << { id: id, cards: cards }
          end
        end
      end
    end

    def take_action(action_name, *args)
      @ws_client.send([action_name, *args].join(':'))
      self
    end

    def game_state
      @game_state.dup.freeze
    end
  end
end
