# frozen_string_literal: true

require_relative 'command_line'
require_relative 'directory'
require_relative 'formatter'

class LsCommand
  def self.execute
    command_line = CommandLine.new
    options = command_line.options
    paths = command_line.paths
    new.render(options, paths)
  end

  def render(options, paths)
    directories = paths.map { |path| Directory.new(path) }
    formatter = Formatter.new(options)

    directories.map do |directory|
      formatter.format(directory, paths)
    end.join("\n")
  end
end
