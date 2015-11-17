module Dealer
  class Card
    attr_reader :suit, :rank

    NUMERIC_UNICODE_RANKS = Hash.new { |_, k| k if (2..10).cover?(k) }
    UNICODE_RANK_EXCEPTIONS = { ace: 1, jack: 11, queen: 13, king: 14 }
    RANK_TO_UNICODE_OFFSET = NUMERIC_UNICODE_RANKS.merge(UNICODE_RANK_EXCEPTIONS)
    UNICODE_OFFSET_TO_RANK = NUMERIC_UNICODE_RANKS.merge(UNICODE_RANK_EXCEPTIONS.invert)
    SUIT_TO_UNICODE_OFFSET = { spades: 0xA0, hearts: 0xB0, diamonds: 0xC0, clubs: 0xD0 }
    UNICODE_OFFSET_TO_SUIT = SUIT_TO_UNICODE_OFFSET.invert

    def self.from_face(face)
      unpacked = face.unpack('U')[0]
      Card.new([UNICODE_OFFSET_TO_RANK[unpacked & 0x0F], UNICODE_OFFSET_TO_SUIT[unpacked & 0xF0]])
    end

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
      [0x1F000 | SUIT_TO_UNICODE_OFFSET[suit] | RANK_TO_UNICODE_OFFSET[rank]].pack('U')
    end

    def back
      '🂠'
    end
  end
end
