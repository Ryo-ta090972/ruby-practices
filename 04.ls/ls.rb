# frozen_string_literal: true

COLUMN = 3
SPACE = 2

def filter_names(names)
  names.reject { |name| name.start_with?('.') }.sort
end

def reposition(names)
  row = (names.size.to_f / COLUMN).ceil
  names.each_slice(row).map do |names_by_row|
    names_by_row.values_at(0...row)
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

def output(nested_names)
  repositioned_names = reposition(nested_names)
  max_str_sizes = find_max_str_sizes(repositioned_names)

  repositioned_names.each.map do |names|
    names.each_with_index.map do |name, col|
      name.to_s.ljust(max_str_sizes[col] + SPACE)
    end.join.rstrip
  end.join("\n")
end

if $PROGRAM_NAME == __FILE__
  path = ARGV[0]
  subject_dir = path || '.'
  entry_names = Dir.children(subject_dir)
  filtered_names = filter_names(entry_names)
  puts output(filtered_names)
end
