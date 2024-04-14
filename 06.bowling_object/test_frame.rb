# frozen_string_literal: true

require 'test/unit'
require './frame'

class TestFrame < Test::Unit::TestCase
  def test_calculate_frame_score
    frame = Frame.new('1', '8')
    assert_equal(9, frame.score)
  end
end
