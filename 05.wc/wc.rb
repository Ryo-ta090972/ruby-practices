# frozen_string_literal: true

require 'optparse'

WIDTH_FOR_RJUST_0 = 0
WIDTH_FOR_RJUST_7 = 7

def main
  options = parse_options
  is_stdin = ARGV.empty?
  loaded_attributes = is_stdin ? load_attributes_of_stdin : load_attributes_of_files
  output_text = is_stdin ? to_output_text_from_stdin_attributes(loaded_attributes, options) : to_output_text_from_files_attributes(loaded_attributes, options)
  puts output_text
end

def parse_options
  options = { row: true, word: true, byte: true }

  OptionParser.new do |opts|
    opts.on('-l') { options[:row] = false }
    opts.on('-w') { options[:word] = false }
    opts.on('-c') { options[:byte] = false }
  end.parse!(ARGV)
  options
end

def load_attributes_of_stdin
  stdin = $stdin.read

  [{
    row: stdin.scan(/\n/).size,
    word: stdin.scan(/\S+/).size,
    byte: stdin.bytesize
  }]
end

def load_attributes_of_files
  ARGV.map do |file_path|
    file = File.new(file_path)
    file_text = file.read

    {
      row: file_text.scan(/\n/).size,
      word: file_text.scan(/\S+/).size,
      byte: file_text.bytesize,
      name: file.path
    }
  end
end

def to_output_text_from_stdin_attributes(stdin_attributes, options)
  width_for_rjust = options.one? { |_, bool| !bool } ? WIDTH_FOR_RJUST_0 : WIDTH_FOR_RJUST_7
  output_stdin_attributes = options.all? { |_, bool| bool } ? stdin_attributes : delete_attribute_by_option(stdin_attributes, options)
  format_attributes(output_stdin_attributes, width_for_rjust)
end

def to_output_text_from_files_attributes(files_attributes, options)
  copy_files_attributes = files_attributes.dup
  copy_files_attributes << build_total_attributes(copy_files_attributes) if multiple_files?(copy_files_attributes)

  width_for_rjust = if options.one? { |_, bool| !bool } && !multiple_files?(copy_files_attributes)
                      WIDTH_FOR_RJUST_0
                    else
                      calculate_max_int_length_whole_attributes(copy_files_attributes)
                    end

  output_files_attributes = options.all? { |_, bool| bool } ? copy_files_attributes : delete_attribute_by_option(copy_files_attributes, options)
  format_attributes(output_files_attributes, width_for_rjust)
end

def delete_attribute_by_option(nested_attributes, options)
  nested_attributes.map do |attributes|
    attributes.reject { |key, _| options[key] }
  end
end

def format_attributes(nested_attributes, width)
  nested_attributes.map do |attributes|
    attributes.values.map do |attribute|
      attribute.instance_of?(Integer) ? "#{attribute.to_s.rjust(width)} " : attribute
    end.join.rstrip
  end.join("\n")
end

def multiple_files?(files)
  files.length > 1
end

def build_total_attributes(attributes)
  total_row = attributes.sum { |attribute| attribute[:row] }
  total_word = attributes.sum { |attribute| attribute[:word] }
  total_byte = attributes.sum { |attribute| attribute[:byte] }

  {
    row: total_row,
    word: total_word,
    byte: total_byte,
    name: 'total'
  }
end

def calculate_max_int_length_whole_attributes(nested_attributes)
  nested_attributes.map do |attributes|
    attributes.values.map do |attribute|
      attribute.to_s.length if attribute.instance_of?(Integer)
    end.compact
  end.flatten.max
end

main if $PROGRAM_NAME == __FILE__
