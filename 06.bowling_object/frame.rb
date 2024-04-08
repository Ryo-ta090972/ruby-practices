# frozen_string_literal: true

require './shot'

class Frame
  attr_reader :score

  def initialize(*shots)
    @frames = shots.map { |shot| Shot.new(shot) }
    @score = calculate_frame_score
  end

  def calculate_frame_score
    frame_score = 0

    @frames.each do |shot|
      frame_score += shot.score
    end
    frame_score
  end
end
