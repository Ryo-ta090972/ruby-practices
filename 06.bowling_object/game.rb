# frozen_string_literal: true

require './frame'

STRIKE = 'X'
SPARE = 10

class Game
  attr_reader :score

  def initialize(*table_frames)
    @frames = table_frames.map { |frames| Frame.new(*frames) }
    @score = calculate_normal_score + calculate_bonus_score
  end

  def calculate_normal_score
    normal_score = 0

    10.times do |index|
      normal_score += @frames[index].score
    end
    normal_score
  end

  def calculate_bonus_score
    total_bonus_score = 0

    10.times do |index|
      frame = @frames[index]
      next_frame = @frames[index + 1]
      next_next_frame = @frames[index + 2]

      bonus_score = if strike?(frame) && strike?(next_frame)
                      next_frame.score + next_next_frame.score
                    elsif strike?(frame) && !strike?(next_frame)
                      next_frame.score
                    elsif frame.score == SPARE
                      next_frame.shots[0].score
                    else
                      0
                    end
      total_bonus_score += bonus_score
    end
    total_bonus_score
  end

  def strike?(frame)
    frame.shots[0].mark == STRIKE
  end
end
