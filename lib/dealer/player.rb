require 'securerandom'

module Dealer
  class Player
    attr_reader :id

    def initialize
      @id = SecureRandom.hex(8).freeze
    end

    def to_s
      "player/#{@id}"
    end
  end
end
