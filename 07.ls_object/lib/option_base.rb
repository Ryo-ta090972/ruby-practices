# frozen_string_literal: true

class OptionBase
  attr_reader :is_applied

  def initialize
    @is_applied = false
  end

  def apply
    @is_applied = true
  end

  def execute
    raise NotImplementedError, 'Subclasses must implement abstract_method'
  end
end
