# frozen_string_literal: true

require './lib/option_base'

class OptionReverse < OptionBase
  def apply(entries, _)
    entries.sort.reverse
  end
end
