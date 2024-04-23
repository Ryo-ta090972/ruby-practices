# frozen_string_literal: true

require './frame'

class Game
  def initialize(argv = ARGV[0])
    @marks = argv.split(',')
  end

  def score
    frames = build_frames

    frames.take(10).sum do |frame|
      frame.calculate_score(frames)
    end
  end

  private

  def build_frames
    build_shots.each_slice(2).each_with_index.map { |shots, index| Frame.new(shots, index) }
  end

  def build_shots
    shots = @marks.map { |mark| Shot.new(mark) }
    shots.flat_map { |shot| shot.strike? ? [shot, Shot.new('0')] : shot }
  end
end
