require 'dealer/card_location'
require 'dealer/player'
require 'json'

module Dealer
  module DSL
    def initialize
      @card_locations = {}
      @player_emitter = {}
    end

    def register_connection(&emitter)
      Player.new.tap do |player|
        @player_emitter[player] = emitter
        update(player, player_id: player.id)
        update_all(players: player)
        player_arrived(player) if respond_to?(:player_arrived)
      end
    end

    def deregister_connection(player)
      @player_emitter.remove(player)
      update_all(players: players)
      player_left(player) if respond_to?(:player_left)
    end

    def notify_state
      update_all do |player|
        {
          card_locations: @card_locations.map do |id, location|
            {
              id: id,
              cards: location.state_view(player)
            }
          end
        }
      end
    end

    private

    def update(player, state)
      @player_emitter[player].call(:update, state)
    end

    def update_all(state = nil, &block)
      players.each do |player|
        update(player, state || block.call(player))
      end
    end

    def player_by_id(player_id)
      players.find do |player|
        player.id == player_id
      end
    end

    def players
      @player_emitter.keys
    end

    def card_location(*id)
      @card_locations[Array(id).join('/')] ||= CardLocation.new
    end
  end
end
