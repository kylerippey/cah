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

  def test_deck_should_be_shuffled_upon_creation
    # Let's make sure that creating a deck 3 times and
    # drawing the top card each time results in at least
    # 2 unique cards. This should avoid random test failures
    # in the rare case we draw the same card twice by chance.

    cards = []
    cards << Cah::Deck.new(File.expand_path("../../cards/white.yml", __FILE__)).draw(1).first
    cards << Cah::Deck.new(File.expand_path("../../cards/white.yml", __FILE__)).draw(1).first
    cards << Cah::Deck.new(File.expand_path("../../cards/white.yml", __FILE__)).draw(1).first

    assert cards.uniq.count >= 2, "creating a new deck should shuffle the cards"
  end

end