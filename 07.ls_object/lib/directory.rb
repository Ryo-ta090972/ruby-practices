# frozen_string_literal: true

require './lib/entry'

class Directory
  attr_reader :path, :entries

  def initialize(path)
    @path = path
    @entries = Dir.open(path).sort.map { |entry_name| Entry.new(entry_name, path) }
  end

  def entry_names
    @entries.map(&:name)
  end
end
