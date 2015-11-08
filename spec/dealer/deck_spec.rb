require 'spec_helper'
require 'dealer/deck'

describe Dealer::Deck do
  subject(:deck) { described_class.new }

  describe 'default state' do
    it 'contains 52 cards' do
      expect(deck).to have(52).cards
    end

    it 'contains only unique cards' do
      expect(deck.cards.count).to eq(deck.cards.uniq.count)
    end

    it 'contains cards in random order' do
      expect(deck.cards).to_not eq(described_class.new.cards)
    end
  end
end
