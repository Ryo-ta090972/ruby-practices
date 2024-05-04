# frozen_string_literal: true

require 'optparse'
require './lib/command_line'
require './lib/format'
require 'debug'

class Command
  def initialize(argv = ARGV)
    @command_line = CommandLine.new(argv)
  end

  def ls
    visible_entries = build_visible_entries
    updated_entries = option.execute(visible_entries, paths)
    Format.arrange(updated_entries, option)
  end

  private

  def build_visible_entries
    binding.break
    paths.map do |path|
      Dir.entries(path).reject { |entry| entry.start_with?('.')}.sort
    end
  end

  def option
    @command_line.option
  end

  def paths
    @command_line.paths
  end
end
