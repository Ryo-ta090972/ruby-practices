# frozen_string_literal: true

require 'optparse'
require 'debug'

class Command
  def initialize(argv = ARGV)
    @paths = argv.empty? ? ['.'] : argv
  end

  def ls
    @paths.map {|path| Dir.entries(path)}
  end
end