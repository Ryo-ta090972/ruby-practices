# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../ls'

class LsTest < Minitest::Test
  def test_not_option
    assert_equal %w[test1 test2], not_option(%w[test1 test2 .test3 .test4])
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

  def test_str_max_size_of_each_col_val1
    result = str_max_size_of_each_col([['1']])
    expected = [1]
    assert_equal expected, result
  end

  def test_str_max_size_of_each_col_val6_col3
    result = str_max_size_of_each_col([%w[1 22 666666], %w[333 4444 nil]])
    expected = [3, 4, 6]
    assert_equal expected, result
  end

  def test_str_for_output_val4_col3_space2
    targets = %w[test1 test2 test3 test4]
    result = str_for_output(targets, 3, 2)
    expected = <<~TEXT.chomp
      test1  test3  test4
      test2
    TEXT
    assert_equal expected, result
  end

  def test_str_for_output_val7_col3_space3
    targets = %w[test1 test2 test3test3 test4 test5 test6 test7]
    result = str_for_output(targets, 3, 3)
    expected = <<~TEXT.chomp
      test1        test4   test7
      test2        test5
      test3test3   test6
    TEXT
    assert_equal expected, result
  end
end
