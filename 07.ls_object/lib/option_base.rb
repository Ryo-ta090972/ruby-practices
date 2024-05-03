# frozen_string_literal: true

class OptionBase
  def initialize
    @is_active = false
  end

  def activate
    @is_active = true
  end

  def execute(entries, path)
    @is_active ? apply_option(entries, path) : apply_default_behavior(entries, path)
  end

  private

  def apply_option(entries, path)
    raise NotImplementedError, "#{self.class.name} must implement abstract_method"
  end

  def apply_default_behavior(entries, path)
    raise NotImplementedError, "#{self.class.name} must implement abstract_method"
  end
end
