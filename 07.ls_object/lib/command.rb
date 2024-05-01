# frozen_string_literal: true

require 'optparse'
require 'debug'

class Command
  def self.ls(argv = ARGV)
    self.new.ls(argv)
  end

  def ls(argv)
    build_output_text(argv)
  end

  private

  def build_output_text(argv)
    argv
  end
end