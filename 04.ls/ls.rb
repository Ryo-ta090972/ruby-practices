# frozen_string_literal: true

require 'optparse'
require 'etc'

COLUMN = 3
BLOCK_SIZE = 4

FILE_TYPE = {
  '01' => 'p',
  '02' => 'c',
  '04' => 'd',
  '10' => '-',
  '12' => 'l',
  '14' => 's'
}.freeze

PERMISSION = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

IS_AUTHORITY = {
  '0' => false,
  '1' => true,
  '2' => true,
  '4' => true
}.freeze

INDEX_AUTHORITY = {
  '1' => 8,
  '2' => 5,
  '4' => 2
}.freeze

AUTHORITY_TYPE = {
  '1' => { 'x' => 't', '-' => 'T' },
  '2' => { 'x' => 's', '-' => 'S' },
  '4' => { 'x' => 's', '-' => 'S' }
}.freeze

def main
  options = parse_options
  target_dir_path = ARGV.empty? ? '.' : ARGV[0]
  names = Dir.entries(target_dir_path)
  sorted_names = sort_names(names, options)
  loaded_names = load_names(sorted_names, target_dir_path, options)
  formatted_names = options[:l] ? format_attributes(loaded_names) : format_names(loaded_names)
  puts formatted_names
end

def parse_options
  options = {}
  OptionParser.new do |opts|
    opts.on('-a') { options[:a] = true }
    opts.on('-r') { options[:r] = true }
    opts.on('-l') { options[:l] = true }
  end.parse!(ARGV)
  options
end

def sort_names(names, options)
  sorted_names = names.sort_by(&:upcase)
  options[:r] ? sorted_names.reverse : sorted_names
end

def load_names(names, path, options)
  loaded_names = options[:a] ? names : names.reject { |name| name.start_with?('.') }
  options[:l] ? load_attributes(loaded_names, path) : loaded_names
end

def load_attributes(names, path)
  total_block_size = 0

  loaded_attributes = names.each.map do |name|
    name_path = File.absolute_path(name, path)
    file_stat = File::Stat.new(name_path)
    total_block_size += (file_stat.size.to_f / file_stat.blksize).ceil * BLOCK_SIZE
    attributes = []

    attributes << load_type_and_permission(file_stat)
    attributes << file_stat.nlink
    attributes << Etc.getpwuid(file_stat.uid).name
    attributes << Etc.getgrgid(file_stat.gid).name
    attributes << file_stat.size
    attributes << file_stat.mtime.strftime('%b %e %H:%M')
    attributes << name
  end

  total = ["total #{total_block_size}"]
  [total, *loaded_attributes]
end

def load_type_and_permission(file)
  file_number = file.mode.to_s(8).rjust(6, '0')
  type_number = file_number[0, 2]
  authority_number = file_number[2, 1]
  permission_number = file_number[3, 3]

  permission = to_permission(permission_number)
  authority_permission = IS_AUTHORITY[authority_number] ? to_authority(permission, authority_number) : permission
  FILE_TYPE[type_number] + authority_permission
end

def to_permission(numbers)
  numbers.each_char.map do |number|
    PERMISSION[number]
  end.join
end

def to_authority(permission, number)
  authority_permission = permission.dup
  index = INDEX_AUTHORITY[number]
  authority_permission[index] = AUTHORITY_TYPE[number][authority_permission[index]]
  authority_permission
end

def format_attributes(attributes)
  max_str_sizes = find_max_str_sizes(attributes[1..])

  attributes.each.map do |attributes_for_row|
    attributes_for_row.each_with_index.map do |attribute, col|
      if attribute.instance_of?(Integer)
        "#{attribute.to_s.rjust(max_str_sizes[col])} "
      else
        "#{attribute.to_s.ljust(max_str_sizes[col])} "
      end
    end.join.rstrip
  end.join("\n")
end

def format_names(names)
  repositioned_names = reposition(names)
  max_str_sizes = find_max_str_sizes(repositioned_names)

  repositioned_names.each.map do |names_for_row|
    names_for_row.each_with_index.map do |name, col|
      "#{name.to_s.ljust(max_str_sizes[col])}  "
    end.join.rstrip
  end.join("\n")
end

def find_max_str_sizes(nested_texts)
  str_sizes = []
  nested_texts.each do |names|
    names.each_with_index do |name, col|
      str_sizes[col] ||= []
      str_sizes[col] << name.to_s.size
    end
  end

  str_sizes.map(&:max)
end

def reposition(names)
  row = (names.size.to_f / COLUMN).ceil
  names.each_slice(row).map do |names_for_row|
    names_for_row.values_at(0...row)
  end.transpose
end

main if $PROGRAM_NAME == __FILE__
