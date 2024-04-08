require 'test/unit'
require './main'
require 'debug'     # binding.break

class TC_Main < Test::Unit::TestCase
  def test_build_frames
    main = Main.new('1,X')
    main.build_frames
    assert_equal( ['1', 'X', '0'], main.frames )
  end
end
