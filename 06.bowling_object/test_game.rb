# frozen_string_literal: true

require 'test/unit'
require './game'

class TestGame < Test::Unit::TestCase
  def test_calculate_score_case_noting_bonus_score
    scores = [%w[1 1], %w[2 2], %w[3 3], %w[4 4], %w[5 0], %w[6 0], %w[7 0], %w[8 0], %w[9 0], %w[0 0]]
    game = Game.new(*scores)
    assert_equal(55, game.score)
  end

  def test_calculate_score_case_spare
    scores = [%w[1 9], %w[2 0], %w[0 0], %w[0 0], %w[0 0], %w[0 0], %w[0 0], %w[0 0], %w[0 0], %w[0 0]]
    game = Game.new(*scores)
    assert_equal(14, game.score)
  end

  def test_calculate_score_case_strike
    scores = [%w[X 0], %w[2 3], %w[X 0], %w[X 0], %w[X 0], %w[0 0], %w[0 0], %w[0 0], %w[0 0], %w[0 0]]
    game = Game.new(*scores)
    assert_equal(80, game.score)
  end

  def test_calculate_score_case_final_frame_spare
    scores = [%w[0 0], %w[0 0], %w[0 0], %w[0 0], %w[0 0], %w[0 0], %w[0 0], %w[0 0], %w[0 0], %w[1 9], ['5']]
    game = Game.new(*scores)
    assert_equal(15, game.score)
  end

  def test_calculate_score_case_final_frame_strike
    scores = [%w[0 0], %w[0 0], %w[0 0], %w[0 0], %w[0 0], %w[0 0], %w[0 0], %w[0 0], %w[0 0], %w[X 0], %w[4 6]]
    game = Game.new(*scores)
    assert_equal(20, game.score)
  end

  def test_calculate_score_case_all_strike
    scores = [%w[X 0], %w[X 0], %w[X 0], %w[X 0], %w[X 0], %w[X 0], %w[X 0], %w[X 0], %w[X 0], %w[X 0], %w[X 0], %w[X 0]]
    game = Game.new(*scores)
    assert_equal(300, game.score)
  end
end
