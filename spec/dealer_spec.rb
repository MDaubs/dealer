require 'spec_helper'
require_relative '../samples/go_fish'

describe Dealer do
  it 'plays go fish' do
    server = Dealer::Server.new(GoFish.new, 9292).start
    sleep 0.1
    player1 = Dealer::Client.new('ws://localhost:9292/')
    sleep 0.1
    player2 = Dealer::Client.new('ws://localhost:9292/').take_action(:start_game)
    sleep 0.1

    # Each player sees seven cards in their hand
    expect(player1.card_locations).to include a_hash_including('id' => "player/#{player1.player_id}/hand", 'cards' => card_faces(7))
    expect(player2.card_locations).to include a_hash_including('id' => "player/#{player2.player_id}/hand", 'cards' => card_faces(7))

    # Each player sees the back of the other players hand
    expect(player1.card_locations).to include a_hash_including('id' => "player/#{player2.player_id}/hand", 'cards' => card_backs(7))
    expect(player2.card_locations).to include a_hash_including('id' => "player/#{player1.player_id}/hand", 'cards' => card_backs(7))

    # Each player sees the back of the remaining cards in the ocean
    expect([player1, player2].map(&:card_locations)).to all include a_hash_including('id' => 'ocean', 'cards' => card_backs(38))

    # Player 1 asks player 2 for a card they have in their hand
    random_card_in_player2s_hand = Dealer::Card.from_face(player2.card_locations.find { |l| l['id'] == "player/#{player2.player_id}/hand" }['cards'].chars.sample)
    player1.take_action(:ask_for_cards_ranked, rank_requested: random_card_in_player2s_hand.rank, player_asked: player2.player_id)

    # Player 2 gives player 1 cards that match that rank
    player1s_cards = player1.card_locations.find { |l| l['id'] == "player/#{player1.player_id}/hand" }['cards'].chars
    player2s_cards = player2.card_locations.find { |l| l['id'] == "player/#{player2.player_id}/hand" }['cards'].chars
    expect(player1s_cards).to include a_card_having_rank(random_card_in_player2s_hand.rank)
    expect(player2s_cards).to_not include a_card_having_rank(random_card_in_player2s_hand.rank)
  end
end
