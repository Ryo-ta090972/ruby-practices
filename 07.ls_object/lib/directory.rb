# frozen_string_literal: true

require_relative 'file_detail'

class Directory
  attr_reader :path, :files

  FILE_DETAILS = %i[
    type_and_permission
    nlink
    uid
    gid
    size
    mtime
    name
  ].freeze

  def initialize(path)
    @path = path
    @files = Dir.open(path).sort.map { |file_name| FileDetail.new(file_name, path) }
  end

  def file_names
    @files.map(&:name)
  end

  def find_max_size_of_file_details(files)
    FILE_DETAILS.each_with_object({}) do |detail, max_sizes|
      max_sizes[detail] = find_max_size_of_file_detail(files, detail)
    end
  end

  private

  def find_max_size_of_file_detail(files, detail)
    files.map { |file| file.send(detail).to_s.size }.max
  end
end
