# frozen_string_literal: true

require 'optparse'

class CommandLine
  attr_reader :options, :paths

  def initialize(argv = ARGV)
    @options = parse_options(argv)
    @paths = argv.empty? ? ['.'] : argv.sort
  end

  private

  def parse_options(argv)
    options = {}
    OptionParser.new do |opts|
      opts.on('-a') { options[:all] = true }
      opts.on('-r') { options[:reverse] = true }
      opts.on('-l') { options[:long] = true }
    end.parse!(argv)
    options
  end
end
