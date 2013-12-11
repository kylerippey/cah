module Cah
  class Player
    attr_reader :username, :hand, :won_cards

    def initialize(game, username)
      @game = game
      @username = username
      @hand = []
      @won_cards = []

      replenish
    end

    def score
      won_cards.count
    end

    def play_card(card)
      @game.play_card(self, card)
    end

    def choose_winner(card)
      @game.choose_winner(self, card)
    end

    def leave_game
      @game.leave(username)
    end

    def replenish
      @hand += @game.white_deck.draw(CARDS_IN_HAND - @hand.count)
    end

    def czar?
      @game.czar == username
    end

    def award_card(black_card)
      @won_cards += Array(black_card)
    end
  end
end