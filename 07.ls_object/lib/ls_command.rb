# frozen_string_literal: true

require_relative 'command_line'
require_relative 'directory'
require_relative 'formatter'

class LsCommand
  def self.execute
    command_line = CommandLine.new(ARGV)
    options = command_line.options
    paths = command_line.paths
    new.generate(options, paths)
  end

  def generate(options, paths)
    directories = paths.map { |path| Directory.new(path) }
    formatter = Formatter.new(options[:all], options[:reverse], options[:long])

    directories.map do |directory|
      formatter.format(directory, paths)
    end.join("\n")
  end
end
