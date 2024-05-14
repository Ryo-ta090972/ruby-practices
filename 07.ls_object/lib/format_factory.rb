# frozen_string_literal: true

require './lib/short_format'
require './lib/long_format'

class FormatFactory
  def self.create(option, entry_groups)
    new.create(option, entry_groups)
  end

  def create(option, entry_groups)
    option.long.is_active ? LongFormat.new(entry_groups) : ShortFormat.new(entry_groups)
  end
end
