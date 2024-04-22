# frozen_string_literal: true

class Shot
  STRIKE = 'X'

  def initialize(mark)
    @mark = mark
  end

  def score
    @mark == STRIKE ? 10 : @mark.to_i
  end

  def strike?
    @mark == STRIKE
  end
end
