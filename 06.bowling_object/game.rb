# frozen_string_literal: true

class Game
  def initialize(*frames)
    @frames = frames.map { |frame| Frame.new(frame) }
  end
end
