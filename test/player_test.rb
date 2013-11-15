require 'test_helper'

class PlayerTest < MiniTest::Unit::TestCase

  def test_player_keeps_track_of_score
    @deck = Cah::Deck.new(File.expand_path("../../cards/black.yml", __FILE__))

    card = @deck.draw

    @player = Cah::Player.new("TestPlayer")

    assert_equal 0, @player.score, "player score should be 0"

    @player.award_card(card)

    assert_equal 1, @player.score, "player score should be 1"
  end

end