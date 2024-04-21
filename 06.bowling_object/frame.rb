# frozen_string_literal: true

require './shot'

class Frame
  attr_reader :first_mark

  def initialize(first_mark, second_mark)
    @first_mark = Shot.new(first_mark)
    @second_mark = Shot.new(second_mark)
  end

  def score
    @first_mark.score + @second_mark.score
  end

  def strike?
    @first_mark.score == 10
  end

  def spare?
    @first_mark.score + @second_mark.score == 10
  end
end
