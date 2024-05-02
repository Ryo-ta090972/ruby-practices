# frozen_string_literal: true

require 'test/unit'
require_relative '../lib/command'
require 'debug'

class CommandTest < Test::Unit::TestCase
  def test_ls_for_path
    binding.break
    argv = []
    result = Command.new(argv).ls
    expected = [[".", "..", "TODO.txt", "test", ".gitkeep", "lib"]]
    assert_equal(expected, result)
  end

  def test_ls_for_paths
    argv = ['.', './test']
    result = Command.new(argv).ls
    expected = [[".", "..", "TODO.txt", "test", ".gitkeep", "lib"], [".", "..", "command_test.rb"]]
    assert_equal(expected, result)
  end

  def test_ls_option_all
    argv = ['-a']
    result = Command.new(argv).ls
    expected = [[".", "..", "TODO.txt", "test", ".gitkeep", "lib"]]
    assert_equal(expected, result)
  end

  def test_ls_option_reverse
    argv = ['-r']
    result = Command.new(argv).ls
    expected = [[".", "..", "TODO.txt", "test", ".gitkeep", "lib"]]
    assert_equal(expected, result)
  end

  def test_ls_option_long
    argv = ['-l']
    result = Command.new(argv).ls
    expected = [[".", "..", "TODO.txt", "test", ".gitkeep", "lib"]]
    assert_equal(expected, result)
  end
end
