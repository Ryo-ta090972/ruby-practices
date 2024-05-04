# frozen_string_literal: true

require './lib/option_base'

class OptionAll < OptionBase
  def apply(entries, path)
    Dir.entries(path).sort
  end
end
