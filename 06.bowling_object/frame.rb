# frozen_string_literal: true

class Frame
  def initialize(*shots)
    @shots = shots.map { |shot| Shot.new(shot) }
  end
end
