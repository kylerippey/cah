require 'test_helper'

class PlayerTest < MiniTest::Unit::TestCase

  def test_player_keeps_track_of_username
    game = Cah::Game.new
    player = game.join("Bob")
    assert "Bob", player.username
  end

  def test_player_draws_cards_upon_joining_a_game
    game = Cah::Game.new
    player = game.join("Bob")
    assert_equal 10, player.hand.count, "player should have a hand of cards"
  end

  def test_player_knows_when_its_the_czar
    game = Cah::Game.new
    player_alice = game.join("Alice")
    player_bob = game.join("Bob")

    game.start

    assert player_alice.czar?, "alice should be czar"
    assert !player_bob.czar?, "bob should not be czar"
  end

end