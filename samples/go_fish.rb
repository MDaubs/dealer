require 'dealer/dsl'
require 'dealer/deck'

class GoFish
  include Dealer::DSL

  def player_start_game(*_)
    card_location(:ocean)
      .show(:back_of_cards, to: players)
      .populate(Dealer::Deck.new.cards)

    players.each do |player|
      card_location(player, :hand)
        .show(:front_of_cards, to: player)
        .show(:back_of_cards, to: players)
    end

    card_location(:ocean).move_top_card_to(player_hands.cycle(7))
  end

  private

  def player_hands
    players.map do |player|
      card_location(player, :hand)
    end
  end
end
