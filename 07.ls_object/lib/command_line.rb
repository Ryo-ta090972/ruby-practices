# frozen_string_literal: true

class CommandLine
  attr_reader :options, :paths

  def initialize(argv)
    @options = parse_option(argv)
    @paths = argv.empty? ? ['.'] : argv
  end

  def parse_option(argv)
    options = {}
    OptionParser.new do |opts|
      opts.on('-a') { options[:a] = true }
      opts.on('-r') { options[:r] = true }
      opts.on('-l') { options[:l] = true }
    end.parse!(argv)
    options
  end
end