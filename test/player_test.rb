require 'test_helper'

class PlayerTest < MiniTest::Unit::TestCase

  def test_player_keeps_track_of_name
    @player = Cah::Player.new("TestPlayer")

    assert "TestPlayer", @player.username
  end

  def test_player_keeps_track_of_score
    @player = Cah::Player.new("TestPlayer")

    assert_equal 0, @player.score, "player score should be 0"

    @player.award_card("This is a card.")

    assert_equal 1, @player.score, "player score should be 1"
  end

end