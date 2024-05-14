# frozen_string_literal: true

require './lib/option_all'
require './lib/option_reverse'
require './lib/option_long'

class OptionController
  attr_reader :long

  def initialize
    @all = OptionAll.new
    @reverse = OptionReverse.new
    @long = OptionLong.new
  end

  def activate(type)
    option = instance_variable_get(type)
    option&.send(:activate)
  end

  def execute(entry_groups)
    entry_groups.transform_values do |group_entries|
      instance_variables.reduce(group_entries) do |current_entries, type|
        option = instance_variable_get(type)
        option&.execute(current_entries, entry_groups.key(group_entries))
      end
    end
  end
end
