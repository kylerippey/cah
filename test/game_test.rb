require 'test_helper'

class GameTest < MiniTest::Unit::TestCase

  def test_can_start_and_play_round
    @game = Cah::Game.new

    assert(!@game.started?, "game should report that it has not yet started")
    assert(@game.white_deck.length > 0, "expected to have white cards")
    assert(@game.black_deck.length > 0, "expected to have black cards")

    assert_nil(@game.black_card)

    # join game
    @player = @game.join("kyle")
    assert_equal(1, @game.players.count)
    assert_equal(1, @game.czar_order.count)
    assert_equal(10, @player.cards.count)

    @player2 = @game.join("jeff")
    assert_equal(2, @game.players.count)
    assert_equal(2, @game.czar_order.count)
    assert_equal(10, @player2.cards.count)

    @player3 = @game.join("katie")
    assert_equal(3, @game.players.count)
    assert_equal(3, @game.czar_order.count)
    assert_equal(10, @player3.cards.count)

    assert_nil(@game.black_card, "shouldn't have a black card until the game starts")

    # start the game
    @game.start

    assert(@game.started?, "game should report that it has started")

    black_card = @game.black_card
    assert(black_card, "should be a selected black card")
    czar = @game.czar
    assert(!czar.empty?, "should have a czar")

    # people play cards
    assert_equal(false, @game.play_card("jeff", @player.cards.first), "can't play a card you don't have")
    assert(@game.play_card("jeff", @player2.cards.first))
    assert(@game.play_card("katie", @player3.cards.first))
    assert_equal(false, @game.play_card("kyle", @player.cards.first), "czar should not be able to play a card this round")
    assert_equal(false, @game.play_card("jeff", @player2.cards.last), "should not be able to play multiple cards in a turn")

    assert_equal(2, @game.played_cards.length)

    # czar chooses the first card
    @game.choose_winner(@game.played_cards.values.first)

    # of course, jeff wins
    assert_equal(1, @player2.score)
    assert_equal({'jeff' => 1, 'kyle' => 0, 'katie' => 0}, @game.scores)

    refute_equal(black_card, @game.black_card, "should have chosen a new black card")
    refute_equal(czar, @game.czar, "should have a new czar")
    [@player, @player2, @player3].each do |player|
      assert_equal(10, player.cards.count, "each player should have a full hand")
    end

    # restart the game
    @game.restart

    assert_equal(3, @game.players.count)
    assert_equal(['jeff', 'katie', 'kyle'], @game.players.keys.sort)
    assert_equal({'jeff' => 0, 'kyle' => 0, 'katie' => 0}, @game.scores)
    assert_equal(3, @game.czar_order.count)
    black_card = @game.black_card
    assert(black_card, "should be a selected black card")
    czar = @game.czar
    assert(czar, "should have a czar")
  end

end