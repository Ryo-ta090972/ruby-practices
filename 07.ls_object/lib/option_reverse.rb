# frozen_string_literal: true

require './lib/option_base'

class OptionReverse < OptionBase
  def apply_option(entries, _)
    entries.sort.reverse
  end

  def apply_default_behavior(entries, _)
    entries.sort
  end
end
