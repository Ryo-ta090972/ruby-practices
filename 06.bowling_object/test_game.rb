require 'test/unit'
require './game'
require 'debug'     # binding.break

class TC_Game < Test::Unit::TestCase
  def test_calculate_score_case_noting_bonus_score
    scores = [['1','1'],['2','2'],['3','3'],['4','4'],['5','0'],['6','0'],['7','0'],['8','0'],['9','0'],['0','0']]
    game = Game.new(*scores)
    assert_equal( 55, game.score )
  end

  def test_calculate_score_case_spare
    scores = [['1','9'],['2','0'],['0','0'],['0','0'],['0','0'],['0','0'],['0','0'],['0','0'],['0','0'],['0','0']]
    game = Game.new(*scores)
    assert_equal( 14, game.score )
  end

  def test_calculate_score_case_strike
    scores = [['X','0'],['2','3'],['X','0'],['X','0'],['X','0'],['0','0'],['0','0'],['0','0'],['0','0'],['0','0']]
    game = Game.new(*scores)
    assert_equal( 80, game.score )
  end

  def test_calculate_score_case_final_frame_spare
    scores = [['0','0'],['0','0'],['0','0'],['0','0'],['0','0'],['0','0'],['0','0'],['0','0'],['0','0'],['1','9'],['5']]
    game = Game.new(*scores)
    assert_equal( 15, game.score )
  end

  def test_calculate_score_case_final_frame_strike
    scores = [['0','0'],['0','0'],['0','0'],['0','0'],['0','0'],['0','0'],['0','0'],['0','0'],['0','0'],['X','0'],['4','6']]
    game = Game.new(*scores)
    assert_equal( 20, game.score )
  end

  def test_calculate_score_case_all_strike
    scores = [['X','0'],['X','0'],['X','0'],['X','0'],['X','0'],['X','0'],['X','0'],['X','0'],['X','0'],['X','0'],['X','0'],['X','0']]
    game = Game.new(*scores)
    assert_equal( 300, game.score )
  end
end
