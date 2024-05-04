# frozen_string_literal: true

class OptionBase
  attr_reader :is_active

  def initialize
    @is_active = false
  end

  def activate
    @is_active = true
  end

  def execute(entries, path)
    @is_active ? apply(entries, path) : entries
  end

  private

  def apply(entries, path)
    raise NotImplementedError, "#{self.class.name} must implement abstract_method"
  end
end
