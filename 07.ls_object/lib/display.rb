# frozen_string_literal: true

require './lib/command_line'
require './lib/directory'
require './lib/formatter'

class Display
  def self.output
    command_line = CommandLine.new
    options = command_line.options
    paths = command_line.paths
    new.output(options, paths)
  end

  def output(options, paths)
    directories = paths.map { |path| Directory.new(path) }
    formatter = Formatter.new(options)

    directories.map do |directory|
      formatter.format(directory, paths)
    end.join("\n")
  end
end
