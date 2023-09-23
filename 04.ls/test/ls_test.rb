# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../ls'

class LsTest < Minitest::Test
  def test_not_option
    assert_equal %w[test1 test2], not_option(['test1', 'test2', '.test3', '.test4'])
  end

  def test_generate_val1_row1_col3
    result = generate([1], 3)
    expected = [[1]]
    assert_equal expected, result
  end

  def test_generate_val3_row1_col3
    result = generate((1..3).to_a, 3)
    expected = [[1, 2, 3]]
    assert_equal expected, result
  end

  def test_generate_val3_row3_col1
    result = generate((1..3).to_a, 1)
    expected = [[1], [2], [3]]
    assert_equal expected, result
  end

  def test_generate_val4_row2_col3
    result = generate((1..4).to_a, 3)
    expected = [[1, 3, 4], [2, nil, nil]]
    assert_equal expected, result
  end

  def test_generate_val6_row3_col2
    result = generate((1..6).to_a, 2)
    expected = [[1, 4], [2, 5], [3, 6]]
    assert_equal expected, result
  end

  def test_generate_val10_row4_col3
    result = generate((1..10).to_a, 3)
    expected = [[1, 5, 9], [2, 6, 10], [3, 7, nil], [4, 8, nil]]
    assert_equal expected, result
  end
end
