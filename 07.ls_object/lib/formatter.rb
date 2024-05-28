# frozen_string_literal: true

class Formatter
  COLUMN = 3
  SPACE = 8

  def initialize(options)
    @options = options
  end

  def format(directory, paths)
    target_entries = @options[:all] ? directory.entries : directory.entries.reject { |entry| entry.name.start_with?('.') }
    sorted_entries = @options[:reverse] ? target_entries.reverse : target_entries
    formatter_entries = @options[:long] ? long_format(sorted_entries) : short_format(sorted_entries)
    multiple?(paths) ? ["#{directory.path}:", formatter_entries].join("\n") : formatter_entries
  end

  private

  def long_format(entries)
    attributes = build_attributes(entries)
    total_block_size = entries.sum(&:block_size)
    format_attributes(attributes, total_block_size)
  end

  def build_attributes(entries)
    entries.map do |entry|
      [
        entry.type + entry.permission,
        entry.nlink,
        entry.uid,
        entry.gid,
        entry.size,
        entry.mtime,
        entry.name
      ]
    end
  end

  def format_attributes(rows_attributes, total_block_size)
    head = "total #{total_block_size}"
    body = render_long_format_body(rows_attributes)
    [head, body].join("\n")
  end

  def render_long_format_body(rows_attributes)
    max_sizes = find_max_attribute_sizes(rows_attributes)

    rows_attributes.map do |row_attributes|
      row_attributes.each_with_index.map do |attribute, column|
        max_size = max_sizes[column]

        if last?(row_attributes, column)
          "#{attribute}\n"
        elsif attribute.instance_of?(Integer)
          "#{attribute.to_s.rjust(max_size)} "
        elsif attribute.instance_of?(Time)
          "#{attribute.strftime('%_m %e %H:%M')} "
        else
          "#{attribute.to_s.ljust(max_size)}  "
        end
      end.join
    end.join
  end

  def find_max_attribute_sizes(rows_attributes)
    rows_attributes.transpose.map do |row_attributes|
      row_attributes.map do |attribute|
        attribute.to_s.size
      end.max
    end
  end

  def short_format(entries)
    names = entries.map(&:name)
    row = cal_row(names)
    width = cal_width(names)
    transposed_names = transpose_names(names, row)
    format_names(transposed_names, width)
  end

  def cal_row(names)
    (names.size.to_f / COLUMN).ceil
  end

  def cal_width(names)
    max_string_size = find_max_name_size(names)

    if (max_string_size % SPACE).zero?
      (max_string_size.to_f / SPACE + 1).ceil * SPACE
    else
      (max_string_size.to_f / SPACE).ceil * SPACE
    end
  end

  def find_max_name_size(names)
    names.map do |name|
      name.to_s.size
    end.max
  end

  def transpose_names(names, row)
    names.each_slice(row).map do |sliced_names|
      sliced_names.values_at(0...row)
    end.transpose
  end

  def format_names(rows_names, width)
    rows_names.map do |row_names|
      row_names.each_with_index.map do |name, column|
        last?(row_names, column) ? "#{name}\n" : name.to_s.ljust(width)
      end.join
    end.join
  end

  def last?(array, index)
    index == array.size - 1
  end

  def multiple?(array)
    !array.one? && !array.empty?
  end
end
