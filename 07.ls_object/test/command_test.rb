# frozen_string_literal: true

require 'test/unit'
require_relative '../lib/command'
require 'debug'

class CommandTest < Test::Unit::TestCase
  def test_ls_for_path
    argv = ['.']
    result = Command.new(argv).ls
    expected = <<~TEXT.chomp
    TODO.txt                lib                     test
    TEXT
    
    assert_equal(expected, result)
  end

  def test_ls_for_paths
    argv = ['.', './test']
    result = Command.new(argv).ls
    expected = <<~TEXT.chomp
    .:
    TODO.txt                lib                     test
    
    ./test:
    command_test.rb
    TEXT

    assert_equal(expected, result)
  end

  def test_ls_option_all
    argv = ['-a']
    result = Command.new(argv).ls
    expected = <<~TEXT.chomp
    .                       .gitkeep                lib
    ..                      .vscode                 test
    .gitignore              TODO.txt
    TEXT
    
    assert_equal(expected, result)
  end

  def test_ls_option_reverse
    argv = ['-r']
    result = Command.new(argv).ls
    expected = <<~TEXT.chomp
    test                    lib                     TODO.txt
    TEXT

    assert_equal(expected, result)
  end

  def test_ls_option_long
    argv = ['-l']
    result = Command.new(argv).ls
    expected = <<~TEXT.chomp
    total 16
    -rw-r--r--@  1 ryo  staff  4376  5  1 23:30 TODO.txt
    drwxr-xr-x  14 ryo  staff   448  5  7 13:31 lib
    drwxr-xr-x   3 ryo  staff    96  5  7 15:06 test
    TEXT
    
    assert_equal(expected, result)
  end
end
