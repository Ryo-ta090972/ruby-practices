require 'test/unit'
require './frame'
require 'debug'     # binding.break

class TC_Frame < Test::Unit::TestCase
  def test_calculate_frame_score
    frame = Frame.new(*['1', '8'])
    assert_equal( 9, frame.score )
  end
end
