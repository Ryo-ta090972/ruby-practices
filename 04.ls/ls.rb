# frozen_string_literal: true

require 'optparse'
require 'etc'

COLUMN = 3
FORMAT_TIME = '%b %d %H:%M'
BLOCK_SIZA = 1024

def main
  options = parse_options
  target_dir_path = ARGV.empty? ? '.' : ARGV[0]
  names = Dir.entries(target_dir_path)
  sorted_names = sort_names(names, options)
  filtered_names = filter_names(sorted_names, options)
  formated_names = options[:l] ? format_names(load_names_attribute(filtered_names, target_dir_path), options) : format_names(filtered_names, options)
  puts formated_names
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

def filter_names(names, options)
  options[:a] ? names : names.reject { |name| name.start_with?('.') }
end

def load_names_attribute(names, path)
  total_block_size = 0

  names.each.map do |name|
    name_path = File.absolute_path(name, path)
    name_attribute = File::Stat.new(name_path)
    total_block_size += name_attribute.blksize.to_i / BLOCK_SIZA
    attributes = []

    attributes << load_type_and_permission(name_attribute)
    attributes << name_attribute.nlink
    attributes << Etc.getpwuid(name_attribute.uid).name
    attributes << Etc.getpwuid(name_attribute.gid).name
    attributes << name_attribute.size
    attributes << name_attribute.mtime.strftime(FORMAT_TIME)
    attributes << name
  end.prepend(["total #{total_block_size}"])
end

def load_type_and_permission(name)
  mode_number = name.mode.to_s(8).rjust(6, '0')
  type_number = mode_number[0, 2]
  authority_number = mode_number[2, 1]
  permission_number = mode_number[3, 3]

  type = to_type(type_number)
  is_authority = authority?(authority_number)
  permission = is_authority ? to_authority(to_premission(permission_number), authority_number) : to_premission(permission_number)
  type + permission
end

def to_type(number)
  {
    '01' => 'p',
    '02' => 'c',
    '04' => 'd',
    '10' => '-',
    '12' => 'l',
    '14' => 's'
  }[number]
end

def authority?(number)
  {
    '0' => false,
    '1' => true,
    '2' => true,
    '4' => true
  }[number]
end

def to_premission(numbers)
  numbers.each_char.map do |number|
    {
      '0' => '---',
      '1' => '--x',
      '2' => '-w-',
      '3' => '-wx',
      '4' => 'r--',
      '5' => 'r-x',
      '6' => 'rw-',
      '7' => 'rwx'
    }[number]
  end.join
end

def to_authority(permission, number)
  index = {
    '1' => 8,
    '2' => 5,
    '4' => 2
  }[number]

  authority = {
    '1' => { 'x' => 't', '-' => 'T' },
    '2' => { 'x' => 's', '-' => 'S' },
    '4' => { 'x' => 's', '-' => 'S' }
  }[number]

  permission[index] = authority[permission[index]]
  permission
end

def format_names(names, options)
  names = reposition(names) unless options[:l]
  max_str_sizes = find_max_str_sizes(names)

  names.each.map do |names_for_row|
    names_for_row.each_with_index.map do |name, col|
      if options[:l] && !array_last?(names_for_row, col)
        "#{name.to_s.rjust(max_str_sizes[col])} "
      else
        "#{name.to_s.ljust(max_str_sizes[col])}  "
      end
    end.join.rstrip
  end.join("\n")
end

def reposition(names)
  row = (names.size.to_f / COLUMN).ceil
  names.each_slice(row).map do |names_for_row|
    names_for_row.values_at(0...row)
  end.transpose
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

def array_last?(array, index)
  array[index] == array.last
end

main if $PROGRAM_NAME == __FILE__
