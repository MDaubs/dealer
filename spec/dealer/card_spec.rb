require 'spec_helper'
require 'dealer/card'

describe Dealer::Card do
  describe 'identity' do
    specify "two instances of the same rank and suit can't be used as two keys" do
      card1, card2 = Array.new(2) { described_class.new([10, :diamonds]) }
      expect({ card1 => 'old value' }.merge(card2 => 'new value'))
        .to eq(card1 => 'new value')
        .and eq(card2 => 'new value')
    end

    it 'is equal two another instance having the same rank and suit' do
      card1, card2 = Array.new(2) { described_class.new([10, :diamonds]) }
      expect(card1).to eq(card2)
    end
  end

  describe '#has_rank?' do
    it 'returns true if the card has the specified rank provided as integer or symbol' do
      Dealer::Deck.new.cards.each do |card|
        expect(card).to have_rank(card.rank)
      end
    end

    it 'returns true if the card has the specified rank provided as a string' do
      Dealer::Deck.new.cards.each do |card|
        expect(card).to have_rank(card.rank.to_s)
      end
    end

    it 'returns false if the card does not have the specified rank' do
      Dealer::Deck.new.cards.select { |c| c.suit == :diamonds }.combination(2).each do |card1, card2|
        expect(card1).to_not have_rank(card2.rank)
      end
    end
  end

  describe '#front' do
    it 'returns ace of spades as 🂡' do
      expect(described_class.new([:ace, :spades]).front).to eq('🂡')
    end

    it 'returns 7 of hearts as 🂷' do
      expect(described_class.new([7, :hearts]).front).to eq('🂷')
    end
  end

  describe '#back' do
    it 'returns 🂠 for any card' do
      expect(Dealer::Deck.new.cards.map(&:back)).to all eq('🂠')
    end
  end
end
