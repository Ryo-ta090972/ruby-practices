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

  def activate(type)
    option = instance_variable_get(type)
    option.send(:activate) if option
  end

  def execute(nested_entries, paths)
    nested_entries.each_with_index.map do |entries, index|
      current_entries = entries
      instance_variables.each do |type|
        option = instance_variable_get(type)
        current_entries = option.send(:execute, current_entries, paths[index])
      end
      current_entries
    end
  end
end
