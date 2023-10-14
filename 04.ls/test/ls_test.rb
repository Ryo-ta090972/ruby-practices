# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../ls'

class LsTest < Minitest::Test
  def test_filter_names
    assert_equal %w[test1 test2], filter_names(%w[test1 test2 .test3 .test4])
  end

  def test_reposition_val1_row1
    result = reposition([1])
    expected = [[1]]
    assert_equal expected, result
  end

  def test_reposition_val3_row1_col3
    result = reposition((1..3).to_a)
    expected = [[1, 2, 3]]
    assert_equal expected, result
  end

  def test_reposition_val4_row2_col3
    result = reposition((1..4).to_a)
    expected = [[1, 3], [2, 4]]
    assert_equal expected, result
  end

  def test_reposition_val10_row4_col3
    result = reposition((1..10).to_a)
    expected = [[1, 5, 9], [2, 6, 10], [3, 7, nil], [4, 8, nil]]
    assert_equal expected, result
  end

  def test_find_max_str_sizes_val1
    result = find_max_str_sizes([['1']])
    expected = [1]
    assert_equal expected, result
  end

  def test_find_max_str_sizes_val5_col3
    result = find_max_str_sizes([%w[a bb e], ['ccc', 'dddd', nil]])
    expected = [3, 4, 1]
    assert_equal expected, result
  end

  def test_output_val4
    names = %w[test1 test2 test3 test4]
    result = output(names)
    expected = <<~TEXT.chomp
      test1  test3
      test2  test4
    TEXT
    assert_equal expected, result
  end

  def test_output_val7
    names = %w[test1 test2 test3test3 test4 test5 test6 test7]
    result = output(names)
    expected = <<~TEXT.chomp
      test1       test4  test7
      test2       test5
      test3test3  test6
    TEXT
    assert_equal expected, result
  end
end
