module Cah
  class Card
    attr_accessor :id, :phrase

    def initialize(params)
      @id = params[:id]
      @phrase = params[:phrase]
    end

    def to_s
      "#{id}: #{phrase}"
    end
  end
end