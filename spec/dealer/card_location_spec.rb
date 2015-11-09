require 'spec_helper'
require 'dealer/card_location'

describe Dealer::CardLocation do
  let(:player1) { Dealer::Player.new }
  let(:player2) { Dealer::Player.new }

  subject(:card_location) do
    described_class
      .new
      .populate([[:ace, :spades], [7, :hearts]]
      .map(&Dealer::Card.method(:new)))
  end

  describe 'visibility rules' do
    context 'when there are no rules set' do
      it 'has a nil state view for any player' do
        expect(card_location.state_view(player1)).to be_nil
      end
    end

    context 'when there is a front_of_cards visibility rule for Player 1' do
      before do
        card_location.show(:front_of_cards, to: player1)
      end

      specify "Player 1's state view is the front of all cards" do
        expect(card_location.state_view(player1)).to eq('🂡🂷')
      end

      specify "Player 2's state view is nil" do
        expect(card_location.state_view(player2)).to be_nil
      end
    end

    context 'when there is a back_of_cards visibility rule for Player 2' do
      before do
        card_location.show(:back_of_cards, to: player1)
      end

      specify "Player 1's state view is the back of all cards" do
        expect(card_location.state_view(player1)).to eq('🂠🂠')
      end

      specify "Player 2's state view is nil" do
        expect(card_location.state_view(player2)).to be_nil
      end
    end

    context 'when there is a front_of_cards visibility rule for Player 1 and a back_of_cards visibility rule for all players' do
      before do
        card_location.show(:front_of_cards, to: player1)
        card_location.show(:back_of_cards, to: [player1, player2])
      end

      specify "Player 1's state view is the front of all cards" do
        expect(card_location.state_view(player1)).to eq('🂡🂷')
      end

      specify "Player 2's state view is the back of all cards" do
        expect(card_location.state_view(player2)).to eq('🂠🂠')
      end
    end
  end

  describe 'moving one card between card locations' do
    let(:destination) do
      described_class.new.show(:front_of_cards, to: player1)
    end

    before do
      card_location
        .show(:front_of_cards, to: player1)
        .move_top_card_to(destination)
    end

    it 'removes the card from the source' do
      expect(card_location.state_view(player1)).to_not start_with('🂡')
    end

    it 'adds the card to the destination' do
      expect(destination.state_view(player1)).to eq('🂡')
    end
  end

  describe 'moving two cards between card locations' do
    let(:destinations) do
      Array.new(2) { described_class.new.show(:front_of_cards, to: player1) }
    end

    before do
      card_location
        .show(:front_of_cards, to: player1)
        .move_top_card_to(destinations)
    end

    it 'removes two cards from the source' do
      expect(card_location.state_view(player1)).to be_empty
    end

    it 'adds the first card to the first destination' do
      expect(destinations[0].state_view(player1)).to start_with('🂡')
    end

    it 'adds the second card to the second destination' do
      expect(destinations[1].state_view(player1)).to start_with('🂷')
    end
  end
end
