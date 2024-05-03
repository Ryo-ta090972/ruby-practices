# frozen_string_literal: true

require './lib/option_base'

class OptionAll < OptionBase
  def apply_option(entries, _)
    entries
  end

  def apply_default_behavior(entries, _)
    entries.reject { |entry| entry.start_with?('.')}
  end
end
