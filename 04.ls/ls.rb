# frozen_string_literal: true

COLUMN = 3
SPACE = 2

def filter_names(names)
  names.reject { |name| name.start_with?('.') }.sort
end

def reposition(names)
  row = (names.size.to_f / COLUMN).ceil
  total_blank = names.size % COLUMN

  sliced_names_front = names.slice(0...-total_blank)
  sliced_names_back = names.slice(-total_blank..-1)

  sliced_names_by_row = if row == 2
                          sliced_names_front.each_slice(row).to_a.push(sliced_names_back)
                        else
                          names.each_slice(row)
                        end

  sliced_names_by_row.map do |names_by_row|
    names_by_row.values_at(0...row)
  end.transpose
end

def find_max_str_size(names)
  str_sizes = []

  names.each do |strings|
    strings.each_with_index do |str, col|
      str_sizes[col] ||= []
      str_sizes[col] << str.size unless str.nil?
    end
  end

  str_sizes.map(&:max)
end

def output(names)
  repositioned_names = reposition(names)
  max_str_sizes = find_max_str_size(repositioned_names)

  names_for_output = []

  repositioned_names.each do |strings|
    joined_str = strings.each_with_index.map do |str, col|
      str.ljust(max_str_sizes[col] + SPACE) unless str.nil?
    end.join.rstrip
    names_for_output << joined_str
  end

  names_for_output.join("\n")
end

if $PROGRAM_NAME == __FILE__

  path = ARGV[0]
  subject_dir = path || '.'
  file_and_dir_names = Dir.children(subject_dir)
  filtered_names = filter_names(file_and_dir_names)
  puts output(filtered_names)

end
