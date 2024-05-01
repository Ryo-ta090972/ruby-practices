# frozen_string_literal: true

require_relative '../lib/option'

class CommandLine
  attr_reader :options, :paths

  def initialize(argv)
    @options = parse_option(argv)
    @paths = argv.empty? ? ['.'] : argv
  end

  private

  def parse_option(argv)
    options = []
    OptionParser.new do |opts|
      opts.on('-a') { options << Option.new(:all) }
      opts.on('-r') { options << Option.new(:reverse) }
      opts.on('-l') { options << Option.new(:long) }
    end.parse!(argv)
    options
  end
end