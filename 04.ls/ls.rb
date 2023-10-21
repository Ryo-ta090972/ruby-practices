# frozen_string_literal: true

require 'optparse'

COLUMN = 3
SPACE = 2

def main
  parsed_options = parse_options
  target_dir = ARGV.empty? ? '.' : ARGV[0]
  entry_names = Dir.entries(target_dir)
  sorted_names = sort_names(entry_names, parsed_options)
  filtered_names = filter_names(sorted_names, parsed_options)
  puts output(filtered_names)
end

def parse_options
  options = {}
  OptionParser.new do |opts|
    opts.on('-a') { options[:a] = true }
    opts.on('-r') { options[:r] = true }
  end.parse!(ARGV)
  options
end

def sort_names(names, options)
  options[:r] ? names.sort.reverse : names.sort
end

def filter_names(names, options)
  options[:a] ? names : names.reject { |name| name.start_with?('.') }
end

def output(names)
  repositioned_names = reposition(names)
  max_str_sizes = find_max_str_sizes(repositioned_names)

  repositioned_names.each.map do |names_for_row|
    names_for_row.each_with_index.map do |name, col|
      name.to_s.ljust(max_str_sizes[col] + SPACE)
    end.join.rstrip
  end.join("\n")
end

def reposition(names)
  row = (names.size.to_f / COLUMN).ceil
  names.each_slice(row).map do |names_for_row|
    names_for_row.values_at(0...row)
  end.transpose
end

def find_max_str_sizes(nested_names)
  str_sizes = []
  nested_names.each do |names|
    names.each_with_index do |name, col|
      str_sizes[col] ||= []
      str_sizes[col] << name.to_s.size
    end
  end

  str_sizes.map(&:max)
end

main if $PROGRAM_NAME == __FILE__
