# frozen_string_literal: true

require './shot'

class Frame
  def initialize(shots)
    @shots = shots
  end

  def score
    @shots.sum(&:score)
  end

  def strike?
    @shots[0].strike?
  end

  def spare?
    !strike? && score == 10
  end

  def first_shot_score
    @shots[0].score
  end
end
