# frozen_string_literal: true

require 'optparse'
require 'debug'

WIDTH_FOR_RJUST_0 = 0
WIDTH_FOR_RJUST_7 = 7

def main
  options = parse_options
  loaded_files_attributes = load_files_attributes
  output_text = to_output_text(loaded_files_attributes, options)
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

def load_files_attributes
  if ARGV.empty?
    stdin = $stdin.read

    [{
      row: stdin.scan(/\n/).size,
      word: stdin.scan(/\S+/).size,
      byte: stdin.bytesize
    }]
  else
    ARGV.map do |file_path|
      File.open(file_path) do |file|
        file_text = file.read

        {
          row: file_text.scan(/\n/).size,
          word: file_text.scan(/\S+/).size,
          byte: file_text.bytesize,
          name: file.path
        }
      end
    end
  end
end

def to_output_text(files_attributes, options)
  copy_files_attributes = files_attributes.dup
  copy_files_attributes << build_total_attributes(copy_files_attributes) if multiple_files?(copy_files_attributes)
  width_for_rjust = calculate_width_for_rjust(copy_files_attributes, options)
  output_files_attributes = options.all? { |_, bool| bool } ? copy_files_attributes : delete_attribute_by_option(copy_files_attributes, options)
  format_attributes(output_files_attributes, width_for_rjust)
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

def calculate_width_for_rjust(files, options)
  if ARGV.empty?
    options.one? { |_, bool| !bool } ? WIDTH_FOR_RJUST_0 : WIDTH_FOR_RJUST_7
  else
    options.one? { |_, bool| !bool } && !multiple_files?(files) ? WIDTH_FOR_RJUST_0 : calculate_max_int_length_whole_attributes(files)
  end
end

def calculate_max_int_length_whole_attributes(files)
  files.map do |attributes|
    attributes.values.map do |attribute|
      attribute.to_s.length if attribute.instance_of?(Integer)
    end.compact
  end.flatten.max
end

def delete_attribute_by_option(files, options)
  files.map do |attributes|
    attributes.reject { |key, _| options[key] }
  end
end

def format_attributes(files, width)
  target_key_for_rjust = %w[row word byte]
  files.map do |attributes|
    attributes.map do |key, attribute|
      target_key_for_rjust.include?(key.to_s) ? "#{attribute.to_s.rjust(width)} " : attribute
    end.join.rstrip
  end.join("\n")
end

main if $PROGRAM_NAME == __FILE__
