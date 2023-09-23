# frozen_string_literal: true

NUMBER_COLUMN = 3
SPACE = 2

path = ARGV[0]
subject_dir = path || '.'
flie_and_dir_names = Dir.children(subject_dir)

def not_option(names)
  names.reject { |name| name.start_with?('.') }.sort
end

def generate(targets, col)
  row = (targets.size.to_f / col).ceil
  when_2rows_blank = col - (targets.size - col)
  blank_str = when_2rows_blank.positive? ? targets.pop(when_2rows_blank).map { |t| [t] } : []
  targets.each_slice(row).to_a.push(*blank_str).map! { |t| t.values_at(0...row) }.transpose
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

def output(target, space)
  max_size = str_max_size_of_each_col(target)

  target.each do |element|
    element.each_with_index do |value, index|
      print value.ljust(max_size[index] + space) unless value.nil?
    end
    print "\n"
  end
end

targets = not_option(flie_and_dir_names)
target = generate(targets, NUMBER_COLUMN)
output(target, SPACE)
