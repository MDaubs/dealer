require 'dealer/card_location'
require 'dealer/player'

module Dealer
  module DSL
    def initialize
      @card_locations = {}
      @player_emitter = {}
    end

    def register_connection(&emitter)
      Player.new.tap do |player|
        @player_emitter.each do |_, existing_emitter|
          existing_emitter.call(:player_arrived, player)
        end
        @player_emitter[player] = emitter
        emitter.call(:player_id, player.id)
        player_arrived(player) if respond_to?(:player_arrived)
      end
    end

    def deregister_connection(player)
      @player_emitter.remove(player)
      @player_emitter.each do |_, emitter|
        emitter.call(:player_left, player)
      end
      player_left(player) if respond_to?(:player_left)
    end

    def notify_state
      @player_emitter.each do |player, emitter|
        @card_locations.each do |id, location|
          location.state_view(player).tap do |view|
            emitter.call(:card_location_state, id, view) if view
          end
        end
      end
    end

    private

    def players
      @player_emitter.keys
    end

    def card_location(*id)
      @card_locations[Array(id).join('/')] ||= CardLocation.new
    end
  end
end
