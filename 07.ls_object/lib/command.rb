# frozen_string_literal: true

require 'optparse'
require_relative '../lib/command_line'

class Command
  def initialize(argv = ARGV)
    command_line = CommandLine.new(argv)
    @options = command_line.options
    @paths = command_line.paths
  end

  def ls
    @paths.map {|path| Dir.entries(path)}
  end
end