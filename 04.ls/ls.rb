# frozen_string_literal: true

COLUMN = 3
SPACE = 2

def not_option(names)
  names.reject { |name| name.start_with?('.') }.sort
end

def generate(targets, column)
  row = (targets.size.to_f / column).ceil
  when_2rows_blank = column - (targets.size - column)
  blank_str = when_2rows_blank.positive? ? targets.pop(when_2rows_blank).map { |t| [t] } : []

  targets.each_slice(row).to_a.push(*blank_str).map! do |t|
    t.values_at(0...row)
  end.transpose
end

def str_max_size_of_each_col(target)
  str_size = []

  target.each do |element|
    element.each_with_index do |value, col|
      str_size[col] ||= []
      str_size[col] << value.size unless value.nil?
    end
  end

  str_size.map(&:max)
end

def str_for_output(targets, column, space)
  target = generate(targets, column)
  max_size = str_max_size_of_each_col(target)

  result_lines = []

  target.each do |element|
    line = element.each_with_index.map do |value, col|
      value.ljust(max_size[col] + space) unless value.nil?
    end.join.rstrip
    result_lines << line
  end

  result_lines.join("\n")
end

if $PROGRAM_NAME == __FILE__

  path = ARGV[0]
  subject_dir = path || '.'
  flie_and_dir_names = Dir.children(subject_dir)
  targets = not_option(flie_and_dir_names)
  puts str_for_output(targets, COLUMN, SPACE)

end
