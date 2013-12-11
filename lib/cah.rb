module Cah
  # TODO: Move this to a config file
  CARDS_IN_HAND = 10

  autoload :Deck, 'cah/deck'
  autoload :Game, 'cah/game'
  autoload :Round, 'cah/round'
  autoload :Player, 'cah/player'
  autoload :GameplayException, 'cah/gameplay_exception'
end