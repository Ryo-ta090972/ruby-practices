# frozen_string_literal: true

require 'optparse'
require 'debug'

TARGET_KEY = %w[row word byte].freeze

def main
  options = parse_options
  loaded_texts_attributes = load_texts_attributes
  output_text = to_output_text(loaded_texts_attributes, options)
  puts output_text
end

def parse_options
  options = { row: nil, word: nil, byte: nil, name: nil }

  OptionParser.new do |opts|
    opts.on('-l') { options[:row] = true, options[:name] = true }
    opts.on('-w') { options[:word] = true, options[:name] = true }
    opts.on('-c') { options[:byte] = true, options[:name] = true }
  end.parse!(ARGV)

  if options.values.none?
    options.transform_values { true }
  else
    options.compact
  end
end

def load_texts_attributes
  if ARGV.empty?
    text = $stdin.read
    [calculate_attributes(text)]
  else
    ARGV.map do |file_path|
      File.open(file_path) do |file|
        text = file.read
        calculate_attributes(text, file.path)
      end
    end
  end
end

def calculate_attributes(text, file_name = nil)
  {
    row: text.scan(/\n/).size,
    word: text.scan(/\S+/).size,
    byte: text.bytesize,
    name: file_name
  }
end

def to_output_text(texts_attributes, options)
  copy_texts_attributes = texts_attributes.dup
  copy_texts_attributes << build_total(copy_texts_attributes) if multiple_texts?(copy_texts_attributes)
  width_for_rjust = calculate_max_length(copy_texts_attributes)
  output_texts = delete_attribute(copy_texts_attributes, options)
  format_texts(output_texts, width_for_rjust)
end

def multiple_texts?(texts)
  texts.length > 1
end

def build_total(attributes)
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

def calculate_max_length(texts)
  texts.map do |attributes|
    attributes.map do |key, attribute|
      attribute.to_s.length if TARGET_KEY.include?(key.to_s)
    end.compact
  end.flatten.max
end

def delete_attribute(texts, options)
  texts.map do |attributes|
    attributes.select { |key, _| options[key] }
  end
end

def format_texts(texts, width)
  texts.map do |attributes|
    attributes.map do |key, attribute|
      TARGET_KEY.include?(key.to_s) ? "#{attribute.to_s.rjust(width)} " : attribute
    end.join.rstrip
  end.join("\n")
end

main if $PROGRAM_NAME == __FILE__
