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
    entry_groups.each_with_object({}) do |(path, group_entries), updated_entries|
      current_entries = group_entries
      instance_variables.each do |type|
        option = instance_variable_get(type)
        current_entries = option&.send(:execute, current_entries, path)
        updated_entries[path] = current_entries
      end
    end
  end
end
