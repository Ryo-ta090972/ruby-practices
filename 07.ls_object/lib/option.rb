# frozen_string_literal: true

require './lib/option_all'
require './lib/option_reverse'
require './lib/option_long'

class Option
  def initialize
    @all = OptionAll.new
    @reverse= OptionReverse.new
    @long = OptionLong.new
  end

  def apply(type)
    instance_variable = instance_variable_get("@#{type}")
    instance_variable.send(:apply) if instance_variable
  end
end
