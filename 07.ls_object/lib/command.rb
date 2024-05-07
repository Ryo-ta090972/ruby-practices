# frozen_string_literal: true

require 'optparse'
require './lib/command_line'
require './lib/format_factory'

class Command
  def initialize(argv = ARGV)
    @command_line = CommandLine.new(argv)
  end

  def ls
    visible_entries = build_visible_entries
    updated_entries = option.execute(visible_entries)
    format = FormatFactory.create(option, updated_entries)
    format.execute
  end

  private

  def build_visible_entries
    visible_entries = paths.to_h do |path|
                        [path, Dir.entries(path).reject { |entry| entry.start_with?('.')}.sort]
                      end

    visible_entries.keys.sort.each_with_object({}) { |key, sorted_entries| sorted_entries[key] = visible_entries[key] }
  end

  def option
    @command_line.option
  end

  def paths
    @command_line.paths
  end
end
