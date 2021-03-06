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
      if destination.respond_to?(:each)
        destination.each(&method(:move_top_card_to))
      else
        destination.add_card(@cards.shift)
      end
      self
    end

    def move_cards_with_rank(rank, to:)
      @cards
        .select { |c| c.has_rank?(rank) }
        .each(&to.method(:add_card))
        .each(&@cards.method(:delete))
        .any?
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
