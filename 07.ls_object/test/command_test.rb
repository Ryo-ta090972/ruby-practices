# frozen_string_literal: true

require 'test/unit'
require_relative '../lib/command'
require 'debug'

class CommandTest < Test::Unit::TestCase
  def test_ls_for_path
    # binding.break
    argv = []
    result = Command.new(argv).ls
    expected = [["TODO.txt", "lib", "test"]]
    assert_equal(expected, result)
  end

  def test_ls_for_paths
    argv = ['.', './test']
    result = Command.new(argv).ls
    expected = [["TODO.txt", "lib", "test"], ["command_test.rb"]]
    assert_equal(expected, result)
  end

  def test_ls_option_all
    argv = ['-a']
    result = Command.new(argv).ls
    expected = [[".", "..", ".gitignore", ".gitkeep", ".vscode", "TODO.txt", "lib", "test"]]
    assert_equal(expected, result)
  end

  def test_ls_option_reverse
    argv = ['-r']
    result = Command.new(argv).ls
    expected = [["test", "lib", "TODO.txt"]]
    assert_equal(expected, result)
  end

  def test_ls_option_long
    argv = ['-l']
    result = Command.new(argv).ls
    expected = [[["total 16"],
    ["-rw-r--r--", 1, "ryo", "staff", 4376, "5  1 23:30", "TODO.txt"],
    ["drwxr-xr-x", 10, "ryo", "staff", 320, "5  2 22:57", "lib"],
    ["drwxr-xr-x", 3, "ryo", "staff", 96, "5  1 23:29", "test"]]]
    assert_equal(expected, result)
  end
end
