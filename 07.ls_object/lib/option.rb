# frozen_string_literal: true

require './lib/option_all'
require './lib/option_reverse'
require './lib/option_long'

class Option
  attr_reader :long

  def initialize
    @all = OptionAll.new
    @reverse= OptionReverse.new
    @long = OptionLong.new
  end

  def activate(type)
    option = instance_variable_get(type)
    option.send(:activate) if option
  end

  def execute(nested_entries)
    nested_entries.each_with_object({}) do |(path, entries), updated_entries|
      instance_variables.each do |type|
        option = instance_variable_get(type)
        updated_entries[path] = option.send(:execute, entries, path)
      end
    end
  end
end
