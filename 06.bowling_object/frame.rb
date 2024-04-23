# frozen_string_literal: true

require './shot'

class Frame
  def initialize(shots, index)
    @shots = shots
    @index = index
  end

  def calculate_score(frames)
    normal_score + calculate_bonus_score(frames)
  end

  def normal_score
    @shots.sum(&:score)
  end

  def strike?
    @shots[0].strike?
  end

  def spare?
    !strike? && normal_score == 10
  end

  def first_shot_score
    @shots[0].score
  end

  private

  def calculate_bonus_score(frames)
    next_frame = frames[@index + 1]
    next_next_frame = frames[@index + 2]

    if strike? && next_frame.strike?
      next_frame.first_shot_score + next_next_frame.first_shot_score
    elsif strike? && !next_frame.strike?
      next_frame.normal_score
    elsif spare?
      next_frame.first_shot_score
    else
      0
    end
  end
end
