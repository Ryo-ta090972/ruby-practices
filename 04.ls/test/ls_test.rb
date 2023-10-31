# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../ls'

class LsTest < Minitest::Test
  def test_filter_names_not_option_a
    option = { a: false }
    result = filter_names(%w[test1 test2 .test3 .test4], option)
    expected = %w[test1 test2]
    assert_equal expected, result
  end

  def test_filter_names_option_a
    option = { a: true }
    result = filter_names(%w[. .. test1 test2 .test3], option)
    expected = %w[. .. test1 test2 .test3]
    assert_equal expected, result
  end

  def test_sort_names_not_option_r
    option = { r: false }
    result = sort_names(%w[B a C d], option)
    expected = %w[a B C d]
    assert_equal expected, result
  end

  def test_sort_names_option_r
    option = { r: true }
    result = sort_names(%w[A b D c], option)
    expected = %w[D c b A]
    assert_equal expected, result
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

  def test_format_names_val4
    names = %w[test1 test2 test3 test4]
    result = format_names(names)
    expected = <<~TEXT.chomp
      test1  test3
      test2  test4
    TEXT
    assert_equal expected, result
  end

  def test_format_names_val7
    names = %w[test1 test2 test3test3 test4 test5 test6 test7]
    result = format_names(names)
    expected = <<~TEXT.chomp
      test1       test4  test7
      test2       test5
      test3test3  test6
    TEXT
    assert_equal expected, result
  end

  def test_format_texts_layout_option_l
    options = { a: false, r: false, l: true }
    target_dir_path = '.'
    names = Dir.entries(target_dir_path)
    sorted_names = sort_names(names, options)
    filtered_names = filter_names(sorted_names, options)
    loaded_attributes = load_attributes(filtered_names, target_dir_path)

    result = format_attributes(loaded_attributes)
    expected = `ls -l`.chomp.gsub('\n', ' ')
    assert_equal expected, result
  end
end
