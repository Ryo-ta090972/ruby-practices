# frozen_string_literal: true

require 'test/unit'
require './score'

class TestScore < Test::Unit::TestCase
  def test_build_frames
    score = Score.new('1,8,X')
    score.build_frames
    assert_equal([%w[1 8], %w[X 0]], score.frames)
  end
end
