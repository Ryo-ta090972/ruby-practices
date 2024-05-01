# frozen_string_literal: true

require 'test/unit'
require_relative '../lib/command'
require 'debug'

class LsTest < Test::Unit::TestCase
  def test_ls
    argv = []
    result = Command.new(argv).ls
    expected = [[".", "..", "TODO.txt", "test", ".gitkeep", "lib"]]
    assert_equal(expected, result)
  end
end
