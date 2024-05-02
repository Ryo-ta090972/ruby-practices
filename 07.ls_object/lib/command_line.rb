# frozen_string_literal: true

require './lib/option'

class CommandLine
  attr_reader :option, :paths

  def initialize(argv)
    @option = parse_option(argv)
    @paths = argv.empty? ? ['.'] : argv
  end

  private

  def parse_option(argv)
    option = Option.new
    OptionParser.new do |opts|
      opts.on('-a') { option.apply('all') }
      opts.on('-r') { option.apply('reverse') }
      opts.on('-l') { option.apply('long') }
    end.parse!(argv)
    option
  end
end