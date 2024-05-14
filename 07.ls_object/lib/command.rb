# frozen_string_literal: true

require 'optparse'
require './lib/command_line'
require './lib/format_factory'

class Command
  def initialize(argv = ARGV)
    @command_line = CommandLine.new(argv)
  end

  def ls
    format = create_format
    format.execute
  end

  private

  def create_format
    visible_entries = build_visible_entries
    updated_entries = option.execute(visible_entries)
    FormatFactory.create(option, updated_entries)
  end

  def build_visible_entries
    paths.sort.each_with_object({}) do |path, visible_entries|
      visible_entries[path] = Dir.entries(path).reject { |entry| entry.start_with?('.') }.sort
    end
  end

  def option
    @command_line.option
  end

  def paths
    @command_line.paths
  end
end
