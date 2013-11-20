require 'test_helper'

class DeckTest < MiniTest::Unit::TestCase

  def setup
    @deck = Cah::Deck.new(File.expand_path("../../cards/white.yml", __FILE__))
  end

  def test_can_load_deck_from_yaml
    assert @deck.count > 0, "should have loaded cards from yaml"
  end

  def test_cards_may_be_drawn_and_discarded
    original_count = @deck.count

    hand = @deck.draw(1)

    assert !hand.empty?, "should have drawn a card"

    assert_equal original_count - 1, @deck.count, "deck count should be reduced by one"

    @deck.discard(hand)

    assert_equal 1, @deck.discarded.count
  end

end