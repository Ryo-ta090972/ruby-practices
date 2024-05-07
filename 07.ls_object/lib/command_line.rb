# frozen_string_literal: true

require './lib/option_controller'

class CommandLine
  attr_reader :option, :paths

  def initialize(argv)
    @option = parse_option(argv)
    @paths = argv.empty? ? ['.'] : argv
  end

  private

  def parse_option(argv)
    option = OptionController.new
    OptionParser.new do |opts|
      opts.on('-a') { option.activate(:@all) }
      opts.on('-r') { option.activate(:@reverse) }
      opts.on('-l') { option.activate(:@long) }
    end.parse!(argv)
    option
  end
end
