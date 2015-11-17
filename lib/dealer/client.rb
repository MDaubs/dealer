require 'faye/websocket'
require 'json'

module Dealer
  class Client
    def initialize(adapter_name, *adapter_args)
      @game_state = {}

      @adapter = Dealer::Adapters[adapter_name].new(*adapter_args) do |message|
        message = JSON.parse(message)

        if message['name'] == 'update'
          @game_state.merge!(message['data'])
        else
          raise "Unable to process message: #{message}"
        end
      end
    end

    def take_action(message, data = {})
      @adapter << { 'name' => message, 'data' => data }.to_json
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
