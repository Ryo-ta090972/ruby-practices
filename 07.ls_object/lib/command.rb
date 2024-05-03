# frozen_string_literal: true

require 'optparse'
require './lib/command_line'
require './lib/format'

class Command
  def initialize(argv = ARGV)
    @command_line = CommandLine.new(argv)
  end

  def ls
    entries = build_entries
    updated_entries = option.execute(entries, paths)
    Format.output(updated_entries)
  end

  private

  def build_entries
    paths.map {|path| Dir.entries(path)}
  end

  def option
    @command_line.option
  end

  def paths
    @command_line.paths
  end
end
