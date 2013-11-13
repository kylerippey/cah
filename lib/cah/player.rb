module Cah
  class Player
    attr_reader :username
    attr_accessor :cards, :won_cards

    def initialize(username)
      @username = username
      @cards = []
      @won_cards = []
    end

    def score
      won_cards.count
    end

    def play_card(card)
      cards.delete(card)
    end

    def award_card(black_card)
      @won_cards += black_card
    end

    def replenish(deck)
      @cards += deck.draw(CARDS_IN_HAND - cards.count)
    end
  end
end