module Cah
  # TODO: Move this to a config file
  CARDS_IN_HAND = 10

  autoload :Card, 'cah/card'
  autoload :Deck, 'cah/deck'
  autoload :Game, 'cah/game'
  autoload :Player, 'cah/player'
end