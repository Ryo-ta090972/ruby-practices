# frozen_string_literal: true

class Shot
  STRIKE = 'X'

  def initialize(mark)
    @mark = mark
  end

  def score
    strike? ? 10 : @mark.to_i
  end

  def strike?
    @mark == STRIKE
  end
end
