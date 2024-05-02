# frozen_string_literal: true

require 'optparse'
require './lib/command_line'

class Command
  def initialize(argv = ARGV)
    @command_line = CommandLine.new(argv)
  end

  def ls
    paths.map {|path| Dir.entries(path)}
  end

  def option
    @command_line.option
  end

  def paths
    @command_line.paths
  end
end