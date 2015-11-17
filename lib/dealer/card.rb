module Dealer
  class Card
    attr_reader :suit, :rank

    def initialize((rank, suit))
      @suit = suit
      @rank = rank
    end

    def has_rank?(other_rank)
      rank.to_s == other_rank.to_s
    end

    def hash
      [suit, rank].join.hash
    end

    def eql?(other)
      self == other
    end

    def ==(other)
      hash == other.hash
    end

    def front
      rank_offset = { ace: 1, jack: 11, queen: 13, king: 14 }.fetch(rank, rank)
      suit_offset = { spades: 0xA0, hearts: 0xB0, diamonds: 0xC0, clubs: 0xD0 }.fetch(suit)
      [0x1F000 | suit_offset | rank_offset].pack('U')
    end

    def back
      '🂠'
    end
  end
end
