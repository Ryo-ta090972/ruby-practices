# frozen_string_literal: true

require 'test/unit'
require_relative '../lib/ls_command'

class LsCommandTest < Test::Unit::TestCase
  def setup
    @options = { all: false, reverse: false, long: false }
    @ls_command = LsCommand.new
  end

  def test_ls_when_single_path
    paths = ['./test/sample_dir']
    result = @ls_command.generate(@options, paths)
    expected = <<~TEXT
      Ellen.txt       bob.txt         gim
      Frank.txt       carol.rb        
      alice           dave.js         
    TEXT

    assert_equal(expected, result)
  end

  def test_ls_when_multiple_paths
    paths = ['./test/sample_dir', './test/sample_dir/alice']
    result = @ls_command.generate(@options, paths)
    expected = <<~TEXT
      ./test/sample_dir:
      Ellen.txt       bob.txt         gim
      Frank.txt       carol.rb        
      alice           dave.js         
      
      ./test/sample_dir/alice:
      alice.txt
    TEXT

    assert_equal(expected, result)
  end

  def test_ls_when_single_path_and_option_all
    @options = { all: true }
    paths = ['./test/sample_dir']
    result = @ls_command.generate(@options, paths)
    expected = <<~TEXT
      .                       .alice_hidden           alice
      ..                      .bob_hidden.txt         bob.txt
      .Carol_hidden.rb        .ellen_hidden.txt       carol.rb
      .Dave_hidden.js         Ellen.txt               dave.js
      .Frank_hidden.txt       Frank.txt               gim
    TEXT

    assert_equal(expected, result)
  end

  def test_ls_when_single_path_and_option_reverse
    @options = { reverse: true }
    paths = ['./test/sample_dir']
    result = @ls_command.generate(@options, paths)
    expected = <<~TEXT
      gim             bob.txt         Ellen.txt
      dave.js         alice           
      carol.rb        Frank.txt       
    TEXT

    assert_equal(expected, result)
  end

  def test_ls_when_single_path_and_option_long
    @options = { long: true }
    paths = ['./test/sample_dir']
    result = @ls_command.generate(@options, paths)
    expected = <<~TEXT
    total 0
    -rw-r--r--  1 ryo  staff   0  5  7 18:09 Ellen.txt
    -rw-r--r--  1 ryo  staff   0  5  7 18:10 Frank.txt
    drwxr-xr-x  3 ryo  staff  96  5 30 15:59 alice
    -rw-r-Sr--  1 ryo  staff   0  5  7 18:08 bob.txt
    -rw-r--r--  1 ryo  staff   0  5  7 18:08 carol.rb
    -rw-r--r--  1 ryo  staff   0  5  7 18:08 dave.js
    drwxr-xr-t  2 ryo  staff  64  5  7 18:20 gim
    TEXT

    assert_equal(expected, result)
  end

  def test_ls_when_multiple_paths_and_option_all_long
    @options = { all: true, long: true }
    paths = ['./test/sample_dir', './test/sample_dir/alice']
    result = @ls_command.generate(@options, paths)
    expected = <<~TEXT
      ./test/sample_dir:
      total 0
      drwxr-xr-x  15 ryo  staff  480  5 30 15:59 .
      drwxr-xr-x   4 ryo  staff  128  5 31 18:41 ..
      -rw-r--r--   1 ryo  staff    0  5  7 18:11 .Carol_hidden.rb
      -rw-r--r--   1 ryo  staff    0  5  7 18:11 .Dave_hidden.js
      -rw-r--r--   1 ryo  staff    0  5  7 18:11 .Frank_hidden.txt
      -rw-r--r--   1 ryo  staff    0  5  7 18:10 .alice_hidden
      -rw-r--r--   1 ryo  staff    0  5  7 18:10 .bob_hidden.txt
      -rw-r--r--   1 ryo  staff    0  5  7 18:11 .ellen_hidden.txt
      -rw-r--r--   1 ryo  staff    0  5  7 18:09 Ellen.txt
      -rw-r--r--   1 ryo  staff    0  5  7 18:10 Frank.txt
      drwxr-xr-x   3 ryo  staff   96  5 30 15:59 alice
      -rw-r-Sr--   1 ryo  staff    0  5  7 18:08 bob.txt
      -rw-r--r--   1 ryo  staff    0  5  7 18:08 carol.rb
      -rw-r--r--   1 ryo  staff    0  5  7 18:08 dave.js
      drwxr-xr-t   2 ryo  staff   64  5  7 18:20 gim
      
      ./test/sample_dir/alice:
      total 0
      drwxr-xr-x   3 ryo  staff   96  5 30 15:59 .
      drwxr-xr-x  15 ryo  staff  480  5 30 15:59 ..
      -rw-r--r--   1 ryo  staff    0  5 30 15:59 alice.txt
    TEXT

    assert_equal(expected, result)
  end

  def test_ls_when_single_path_and_option_all_long_reverse
    @options = { all: true, reverse: true, long: true }
    paths = ['./test/sample_dir']
    result = @ls_command.generate(@options, paths)
    expected = <<~TEXT
      total 0
      drwxr-xr-t   2 ryo  staff   64  5  7 18:20 gim
      -rw-r--r--   1 ryo  staff    0  5  7 18:08 dave.js
      -rw-r--r--   1 ryo  staff    0  5  7 18:08 carol.rb
      -rw-r-Sr--   1 ryo  staff    0  5  7 18:08 bob.txt
      drwxr-xr-x   3 ryo  staff   96  5 30 15:59 alice
      -rw-r--r--   1 ryo  staff    0  5  7 18:10 Frank.txt
      -rw-r--r--   1 ryo  staff    0  5  7 18:09 Ellen.txt
      -rw-r--r--   1 ryo  staff    0  5  7 18:11 .ellen_hidden.txt
      -rw-r--r--   1 ryo  staff    0  5  7 18:10 .bob_hidden.txt
      -rw-r--r--   1 ryo  staff    0  5  7 18:10 .alice_hidden
      -rw-r--r--   1 ryo  staff    0  5  7 18:11 .Frank_hidden.txt
      -rw-r--r--   1 ryo  staff    0  5  7 18:11 .Dave_hidden.js
      -rw-r--r--   1 ryo  staff    0  5  7 18:11 .Carol_hidden.rb
      drwxr-xr-x   4 ryo  staff  128  5 31 18:41 ..
      drwxr-xr-x  15 ryo  staff  480  5 30 15:59 .
    TEXT

    assert_equal(expected, result)
  end
end
