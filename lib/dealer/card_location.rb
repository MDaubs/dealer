module Dealer
  class CardLocation
    def initialize
      @cards = []
      @visibility_rules = []
    end

    VISIBILITY_FILTERS = {
      front_of_cards: -> (cards) { cards.map(&:front) },
      back_of_cards: -> (cards) { cards.map(&:back) }
    }

    def show(visibility, to:)
      @visibility_rules << [Array(to), VISIBILITY_FILTERS.fetch(visibility)]
      self
    end

    def state_view(player)
      _, state_view = @visibility_rules.find { |p, _| p.include?(player) }
      state_view.call(@cards).join if state_view
    end

    def move_top_card_to(destination)
      destination.add_card(@cards.shift)
      self
    end

    def populate(cards)
      @cards = cards
      self
    end

    protected

    def add_card(card)
      @cards << card
    end
  end
end
