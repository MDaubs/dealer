require 'faye/websocket'
require 'json'

module Dealer
  class Client
    def initialize(uri)
      @game_state = {}
      @ws_client = Faye::WebSocket::Client.new(uri)

      @ws_client.on :message do |event|
        JSON.parse(event.data).tap do |message|
          if message['name'] == 'update'
            @game_state.merge!(message['data'])
          else
            raise "Unable to process message: #{message}"
          end
        end
      end
    end

    def take_action(action_name, *args)
      @ws_client.send([action_name, *args].join(':'))
      self
    end

    def card_locations
      @game_state['card_locations'].dup.freeze
    end

    def player_id
      @game_state['player_id'].dup.freeze
    end
  end
end
