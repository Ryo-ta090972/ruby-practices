# frozen_string_literal: true

require './lib/option_base'

class OptionAll < OptionBase
  def apply(_, path)
    Dir.entries(path).sort
  end
end
