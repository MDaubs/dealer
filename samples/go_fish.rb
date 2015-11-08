require 'dealer/dsl'
require 'dealer/deck'

class GoFish
  include Dealer::DSL

  def player_start_game(_)
    card_location(:deck)
      .show(:back_of_cards, to: players)
      .populate(Dealer::Deck.new.cards)

    card_location(:ocean)
      .show(:back_of_cards, to: players)

    players.each do |player|
      card_location(player, :hand)
        .show(:front_of_cards, to: player)
        .show(:back_of_cards, to: players)
    end

    7.times do
      players.each do |player|
        card_location(:deck)
          .move_top_card_to(card_location(player, :hand))
      end
    end
  end
end
