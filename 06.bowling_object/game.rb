# frozen_string_literal: true

require './frame'

class Game
  def initialize(argv = ARGV[0])
    @marks = argv.split(',')
  end

  def score
    frames = build_frames
    calculate_normal_score(frames) + calculate_bonus_score(frames)
  end

  private

  def build_frames
    build_shots.map { |shots| Frame.new(shots) }
  end

  def build_shots
    shots = @marks.map { |mark| Shot.new(mark) }
    shots.flat_map { |shot| shot.strike? ? [shot, Shot.new('0')] : shot }.each_slice(2).to_a
  end

  def calculate_normal_score(frames)
    frames.take(10).map(&:score).sum
  end

  def calculate_bonus_score(frames)
    frames.take(10).map.with_index do |frame, index|
      next_frame = frames[index + 1]
      next_next_frame = frames[index + 2]

      if frame.strike? && next_frame.strike?
        next_frame.score + next_next_frame.first_mark.score
      elsif frame.strike? && !next_frame.strike?
        next_frame.score
      elsif frame.spare?
        next_frame.first_mark.score
      else
        0
      end
    end.sum
  end
end
