# frozen_string_literal: true

class Score
  attr_reader :frames

  def initialize(scores = ARGV[0])
    @scores = scores.split(',')
    @frames = []
  end

  def build_frames
    @scores.each do |score|
      if score == 'X'
        @frames << score
        @frames << '0'
      else
        @frames << score
      end
    end
  end
end
