require 'test_helper'

class GameTest < MiniTest::Unit::TestCase

  def test_players_can_join_and_leave
    game = Cah::Game.new

    assert_equal(0, game.players.count)
    assert_equal(0, game.czar_order.count)

    kyle = game.join("kyle")
    assert_equal(1, game.players.count)
    assert_equal(1, game.czar_order.count)

    jeff = game.join("jeff")
    assert_equal(2, game.players.count)
    assert_equal(2, game.czar_order.count)

    kyle.leave_game
    assert_equal(1, game.players.count)
    assert_equal(1, game.czar_order.count)
  end

  def test_new_game_state_is_as_expected
    game = Cah::Game.new
    
    assert !game.started?, "game should report that it has not yet started"

    assert_nil game.black_card, "shouldn't have a black card until the game starts"

    game.start

    assert game.started?, "game should report that it has not yet started"

    assert !!game.black_card, "should have a black card"
  end

  def test_can_start_and_play_round
    @game = Cah::Game.new

    # players join the game
    @kyle = @game.join("kyle")
    @jeff = @game.join("jeff")
    @katie = @game.join("katie")

    # start the game
    @game.start

    initial_czar_order = @game.czar_order.dup

    black_card = @game.black_card
    
    assert(@kyle.czar?, "kyle should be the first czar")

    # people play cards
    @jeff.play_card(@jeff.hand.first)
    @katie.play_card(@katie.hand.first)

    # The card czar may not play a card
    assert_raises Cah::GameplayException, "card czar should not be able to play a card" do
      @kyle.play_card(@kyle.hand.first)
    end

    # Jeff tries to play another card
    assert_raises Cah::GameplayException, "player should only be able to play one card" do
      @jeff.play_card(@jeff.hand.last)
    end

    assert_equal(2, @game.played_cards.length)

    # czar chooses the first card
    @kyle.choose_winner(@game.played_cards.first)

    # of course, jeff wins
    # check scores are correct
    assert_equal [1,0,0], [@jeff.score, @kyle.score, @katie.score]

    refute_equal(black_card, @game.black_card, "should have chosen a new black card")

    assert @jeff.czar?, "jeff should be the second czar"

    # Check that hands were replenished
    [@jeff, @kyle, @katie].each do |player|
      assert_equal(10, player.hand.count, "each player should have a full hand")
    end

    # restart the game
    @game.restart

    # Check for clean game state with retained players
    assert_equal(3, @game.players.count)
    assert_equal ['jeff', 'katie', 'kyle'], @game.players.collect(&:username).sort
    assert_equal(3, @game.czar_order.count)
    black_card = @game.black_card
    assert(black_card, "should be a selected black card")
    assert(!@game.czar.empty?, "should have a czar")
  end

end