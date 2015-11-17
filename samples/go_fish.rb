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

  def player_ask_for_cards_ranked(player_asking, data)
    rank_requested = data['rank_requested']
    player_asked = player_by_id(data['player_asked'])

    if card_location(player_asked, :hand).move_cards_with_rank(rank_requested, to: card_location(player_asking, :hand))
      update_all('last_action' => { 'player_id' => player_asking.id, 'name' => "Asked #{player_asked.id} for #{rank_requested}s and #{player_asking.id} had some." })
    else
      update_all('last_action' => { 'player_id' => player_asking.id, 'name' => "Asked #{player_asked.id} for #{rank_requested}s but #{player_asking.id} had none." })
    end
  end

  private

  def player_hands
    players.map do |player|
      card_location(player, :hand)
    end
  end
end
