# frozen_string_literal: true

require_relative 'file_detail'

class Directory
  attr_reader :path, :entries

  def initialize(path)
    @path = path
    @entries = Dir.open(path).sort.map { |entry_name| FileDetail.new(entry_name, path) }
  end

  def entry_names
    @entries.map(&:name)
  end
end
