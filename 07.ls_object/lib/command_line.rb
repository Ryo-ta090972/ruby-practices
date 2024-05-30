# frozen_string_literal: true

require 'optparse'

class CommandLine
  attr_reader :options, :paths

  def initialize(options_and_paths)
    @options = parse_options!(options_and_paths)
    @paths = options_and_paths.empty? ? ['.'] : options_and_paths.sort
  end

  private

  def parse_options!(options_and_paths)
    options = {}
    OptionParser.new do |opts|
      opts.on('-a') { options[:all] = true }
      opts.on('-r') { options[:reverse] = true }
      opts.on('-l') { options[:long] = true }
    end.parse!(options_and_paths)
    options
  end
end
