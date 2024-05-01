# frozen_string_literal: true

require 'test/unit'
require_relative '../lib/command'
require 'debug'

class LsTest < Test::Unit::TestCase
  def test_ls
    argv = []
    result = Command.ls(argv)
    expected = []
    assert_equal(expected, result)
  end
end
