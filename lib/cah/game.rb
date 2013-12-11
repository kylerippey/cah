module Cah
  class Game

    attr_reader :started_at, :czar_order, :black_card

    def initialize
      @players = {}
      @czar_order = []

      setup
    end

    def join(username)
      raise GameplayException, "#{username} is already playing." if @players.keys.include?(username)

      @czar_order << username
      
      @players[username] = Player.new(self, username)

      # players.fetch(username) do
      #   Player.new(username).tap do |new_player|
      #     players[username] = new_player
      #     czar_order << username
      #     new_player.replenish(white_deck)
      #   end
      # end
    end

    def leave(username)
      # TODO: Handle czar leaving

      czar_order.delete(username)
      player = @players.delete(username)

      if player
        # Discard their cards
        white_deck.discard(player.hand)
        black_deck.discard(player.won_cards)
      end
    end

    def czar
      @czar_order.first
    end

    def start
      raise GameplayException, "Game has already started. Use 'restart' to reset game state." if started?

      # Select the first black card
      @black_card = black_deck.draw(1).first

      @started_at ||= Time.now
    end

    def next_round
      check_game_has_started

      # Replenish hands
      players.each {|player| player.replenish}

      # Discard the played cards
      white_deck.discard(@played_cards.values)

      # Select new card czar
      @czar_order.rotate!

      # Select a new black card
      @black_card = black_deck.draw(1).first
    end

    def restart
      check_game_has_started

      setup

      # Create new player objects
      @players.keys.each do |username|
        @players[username] = Player.new(self, username)
      end

      # Shuffle czar order
      @czar_order.shuffle!

      # Start the new game
      start
    end

    def started?
      !!@started_at
    end

    def players
      @players.values
    end

    def find_player_by_username(username)
      @players[username]
    end

    def white_deck
      @white_deck ||= Deck.new(File.expand_path("../../../cards/white.yml", __FILE__))
    end

    def black_deck
      @black_deck ||= Deck.new(File.expand_path("../../../cards/black.yml", __FILE__))
    end

    # Play a card
    def play_card(player, card)
      check_game_has_started

      raise GameplayException, "The card czar may not play a card." if player.czar?

      raise GameplayException, "Each player may play only one card per round." if @played_cards.keys.include?(player.username)

      card = player.hand.delete(card)

      if card
        @played_cards[player.username] = card
      else
        raise GameplayException, "Invalid card selection."
      end
    end

    # Award black card to the chosen winner
    def choose_winner(czar_player, card)
      check_game_has_started

      raise GameplayException, "Only the card czar (#{czar}) may choose the winning card." unless czar_player.czar?

      raise GameplayException, "Invalid card selection." unless @played_cards.values.include?(card)

      winner = find_player_by_username(@played_cards.invert[card])

      winner.award_card(black_card)

      next_round

      winner
    end

    def played_cards
      @played_cards.values
    end

    private

    def setup
      @started_at = nil

      @black_deck = nil
      @white_deck = nil

      @played_cards = {}
    end

    def check_game_has_started
      raise GameplayException, "The game has not started yet." unless started?
    end

  end
end