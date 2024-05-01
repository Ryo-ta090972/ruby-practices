# frozen_string_literal: true

class Option
  def initialize(type)
    @type = type
  end

  def apply(entries)
    case @type
    when :all
    when :reverse
    when :long
    end
  end
end