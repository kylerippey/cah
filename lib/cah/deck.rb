require 'forwardable'
require 'yaml'

module Cah
  class Deck
    extend Forwardable

    def_delegators :@unplayed, :length, :count

    def initialize(file_path)
      @discarded = []
      @unplayed = YAML.load_file(file_path).shuffle
    end

    def draw(count = 1)
      reshuffle if @unplayed.count < count
      @unplayed.shift(count)
    end

    def discard(cards = [])
      @discarded += cards
    end

    protected

    def reshuffle
      @unplayed += @discarded.shuffle
      @discarded = []
    end

  end
end