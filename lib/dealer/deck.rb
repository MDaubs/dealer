require 'dealer/card'

module Dealer
  class Deck
    SUITS = [:clubs, :diamonds, :hearts, :spades]
    RANKS = [:ace, 2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king]

    attr_reader :cards

    def initialize
      @cards = RANKS.product(SUITS).map(&Card.method(:new)).sort_by { rand }
    end
  end
end
