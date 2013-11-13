module Cah
  class Game

    attr_accessor :players, :started, :white_deck, :black_deck, :black_card, :played_cards, :czar_order

    def initialize
      @players = {}
      @czar_order = []

      setup
    end

    def setup
      @started = nil
      @played_cards = {}
      @czar_order.shuffle!

      @white_deck = Deck.new(File.expand_path("../../../../cards/white.yml", __FILE__))
      @black_deck = Deck.new(File.expand_path("../../../../cards/black.yml", __FILE__))
    end

    def join(username)
      players.fetch(username) do
        Player.new(username).tap do |new_player|
          players[username] = new_player
          czar_order << username
          new_player.replenish(white_deck)
        end
      end
    end

    def leave(username)
      if leaving_player = players[username]
        black_deck.discard(leaving_player.won_cards)
        white_deck.discard(leaving_player.cards)
        players.delete(username)
      end
    end

    def scores
      {}.tap do |hash|
        players.each do |k,v|
          hash[k] = v.score
        end
      end
    end

    def czar?(username)
      czar == username
    end

    def czar
      started? ? czar_order.first : nil
    end

    def play_card(username, card)
      return false if czar?(username)
      return false if played_cards.has_key?(username)
      if card = players.fetch(username).play_card(card)
        played_cards[username] = card
        true
      else
        false
      end
    rescue KeyError
      false
    end

    # Award black card to the chosen winner
    def choose_winner(card)
      players[played_cards.invert[card]].tap do |winner|
        winner.award_card(black_card)
        next_round
      end
    end

    def next_round
      # Discard played white cards
      white_deck.discard(played_cards.values)
      @played_cards = {}

      # Draw new white cards
      players.values.each do |player|
        player.replenish(white_deck)
      end

      # Select new card czar
      czar_order.rotate! if started?

      # Draw next black card
      @black_card = black_deck.draw
    end

    def start
      # czar_order.shuffle
      next_round
      @started = Time.now
    end

    def restart
      setup

      # Players need new hands
      players.keys.each do |username|
        players[username] = Player.new(username)
      end

      start
    end

    def started?
      !!@started
    end

  end
end