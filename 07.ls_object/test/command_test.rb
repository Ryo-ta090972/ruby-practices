# frozen_string_literal: true

require 'test/unit'
require_relative '../lib/command'

class CommandTest < Test::Unit::TestCase
  def test_ls_when_single_path
    argv = ['./test/sample_dir']
    result = Command.new(argv).ls
    expected = <<~TEXT.chomp
      Ellen.txt       bob.txt         gim
      Frank.txt       carol.rb
      alice           dave.js
    TEXT

    assert_equal(expected, result)
  end

  def test_ls_when_multiple_path
    argv = ['./test/sample_dir', './test']
    result = Command.new(argv).ls
    expected = <<~TEXT.chomp
      ./test:
      command_test.rb sample_dir
      
      ./test/sample_dir:
      Ellen.txt       bob.txt         gim
      Frank.txt       carol.rb
      alice           dave.js
    TEXT

    assert_equal(expected, result)
  end

  def test_ls_when_single_path_and_option_all
    argv = ['-a', './test/sample_dir']
    result = Command.new(argv).ls
    expected = <<~TEXT.chomp
      .                       .alice_hidden           alice
      ..                      .bob_hidden.txt         bob.txt
      .Carol_hidden.rb        .ellen_hidden.txt       carol.rb
      .Dave_hidden.js         Ellen.txt               dave.js
      .Frank_hidden.txt       Frank.txt               gim
    TEXT

    assert_equal(expected, result)
  end

  def test_ls_when_single_path_and_option_reverse
    argv = ['-r', './test/sample_dir']
    result = Command.new(argv).ls
    expected = <<~TEXT.chomp
      gim             bob.txt         Ellen.txt
      dave.js         alice
      carol.rb        Frank.txt
    TEXT

    assert_equal(expected, result)
  end

  def test_ls_when_single_path_and_option_long
    argv = ['-l', './test/sample_dir']
    result = Command.new(argv).ls
    expected = <<~TEXT.chomp
      total 0
      -rw-r--r--  1 ryo  staff   0  5  7 18:09 Ellen.txt
      -rw-r--r--  1 ryo  staff   0  5  7 18:10 Frank.txt
      -rwSr--r--  1 ryo  staff   0  5  7 18:07 alice
      -rw-r-Sr--  1 ryo  staff   0  5  7 18:08 bob.txt
      -rw-r--r--  1 ryo  staff   0  5  7 18:08 carol.rb
      -rw-r--r--  1 ryo  staff   0  5  7 18:08 dave.js
      drwxr-xr-t  2 ryo  staff  64  5  7 18:20 gim
    TEXT

    assert_equal(expected, result)
  end

  def test_ls_when_single_path_and_option_all_long
    argv = ['-al', './test/sample_dir']
    result = Command.new(argv).ls
    expected = <<~TEXT.chomp
      total 0
      drwxr-xr-x  15 ryo  staff  480  5  8 07:46 .
      drwxr-xr-x   4 ryo  staff  128  5 15 20:06 ..
      -rw-r--r--   1 ryo  staff    0  5  7 18:11 .Carol_hidden.rb
      -rw-r--r--   1 ryo  staff    0  5  7 18:11 .Dave_hidden.js
      -rw-r--r--   1 ryo  staff    0  5  7 18:11 .Frank_hidden.txt
      -rw-r--r--   1 ryo  staff    0  5  7 18:10 .alice_hidden
      -rw-r--r--   1 ryo  staff    0  5  7 18:10 .bob_hidden.txt
      -rw-r--r--   1 ryo  staff    0  5  7 18:11 .ellen_hidden.txt
      -rw-r--r--   1 ryo  staff    0  5  7 18:09 Ellen.txt
      -rw-r--r--   1 ryo  staff    0  5  7 18:10 Frank.txt
      -rwSr--r--   1 ryo  staff    0  5  7 18:07 alice
      -rw-r-Sr--   1 ryo  staff    0  5  7 18:08 bob.txt
      -rw-r--r--   1 ryo  staff    0  5  7 18:08 carol.rb
      -rw-r--r--   1 ryo  staff    0  5  7 18:08 dave.js
      drwxr-xr-t   2 ryo  staff   64  5  7 18:20 gim
    TEXT

    assert_equal(expected, result)
  end

  def test_ls_when_single_path_and_option_all_long_reverse
    argv = ['-alr', './test/sample_dir']
    result = Command.new(argv).ls
    expected = <<~TEXT.chomp
      total 0
      drwxr-xr-t   2 ryo  staff   64  5  7 18:20 gim
      -rw-r--r--   1 ryo  staff    0  5  7 18:08 dave.js
      -rw-r--r--   1 ryo  staff    0  5  7 18:08 carol.rb
      -rw-r-Sr--   1 ryo  staff    0  5  7 18:08 bob.txt
      -rwSr--r--   1 ryo  staff    0  5  7 18:07 alice
      -rw-r--r--   1 ryo  staff    0  5  7 18:10 Frank.txt
      -rw-r--r--   1 ryo  staff    0  5  7 18:09 Ellen.txt
      -rw-r--r--   1 ryo  staff    0  5  7 18:11 .ellen_hidden.txt
      -rw-r--r--   1 ryo  staff    0  5  7 18:10 .bob_hidden.txt
      -rw-r--r--   1 ryo  staff    0  5  7 18:10 .alice_hidden
      -rw-r--r--   1 ryo  staff    0  5  7 18:11 .Frank_hidden.txt
      -rw-r--r--   1 ryo  staff    0  5  7 18:11 .Dave_hidden.js
      -rw-r--r--   1 ryo  staff    0  5  7 18:11 .Carol_hidden.rb
      drwxr-xr-x   4 ryo  staff  128  5 15 20:06 ..
      drwxr-xr-x  15 ryo  staff  480  5  8 07:46 .
    TEXT

    assert_equal(expected, result)
  end
end
