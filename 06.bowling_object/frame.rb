# frozen_string_literal: true

require './shot'

class Frame
  attr_reader :shots, :score

  def initialize(*shots)
    @shots = shots.map { |shot| Shot.new(shot) }
    @score = 0
    calculate_score
  end

  def calculate_score
    @shots.each { |shot| @score += shot.score }
  end
end
