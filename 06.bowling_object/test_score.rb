require 'test/unit'
require './score'
require 'debug'     # binding.break

class TC_Score < Test::Unit::TestCase
  def test_build_frames
    score = Score.new('1,X')
    score.build_frames
    assert_equal( ['1', 'X', '0'], score.frames )
  end
end
