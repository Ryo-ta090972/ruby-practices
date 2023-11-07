
require 'optparse'
require 'debug'

def main
  options = parse_options
  loaded_files = load_files_of_row_word_byte_names(options)
  formatted_files = format_files(loaded_files)
  puts formatted_files
end

def parse_options
  options = {}
  OptionParser.new do |opts|
    opts.on('-l') { options[:l] = true }
    opts.on('-w') { options[:w] = true }
    opts.on('-c') { options[:c] = true }
  end.parse!(ARGV)
  options
end

def load_files_of_row_word_byte_names(options)
  counted_rows = []
  counted_words = []
  counted_bytes = []

  loaded_files = ARGV.map do |file_path|
    counted_row = count_row(file_path, options)
    counted_word = count_word(file_path, options)
    counted_byte = count_byte(file_path, options)

    counted_rows << counted_row
    counted_words << counted_word
    counted_bytes << counted_byte

    [
    counted_row,
    counted_word,
    counted_byte,
    File.new(file_path).path
    ]
  end.compact

  total_row = counted_rows.include?(nil) ? counted_rows.compact : counted_rows.sum
  total_word = counted_words.include?(nil) ? counted_words.compact : counted_words.sum
  total_byte = counted_bytes.include?(nil) ? counted_bytes.compact : counted_bytes.sum

  total = [total_row, total_word, total_byte, 'total']
  ARGV.size > 1 ? loaded_files << total : loaded_files
end

def count_row(path, options)
  file = File.new(path)
  file.read.scan(/\n/).size if options.empty? || options[:l]
end

def count_word(path, options)
  file = File.new(path)
  file.read.scan(/[\S]+/).size if options.empty? || options[:w]
end

def count_byte(path, options)
  file = File.new(path)
  file.read.bytesize  if options.empty? || options[:c]
end

def format_files(nested_files)
  max_int_length = find_max_int_length(nested_files)

  nested_files.map do |files|
    files.map do |file|
      if file.instance_of?(Integer)
        "#{file.to_s.rjust(max_int_length)} "
      else
        file
      end
    end.join
  end.join("\n")
end

def find_max_int_length(nested_files)
  nested_files.map do |files|
    files.map do |file|
      file.to_s.length if file.instance_of?(Integer)
    end.compact
  end.flatten.max
end

main if $PROGRAM_NAME == __FILE__
