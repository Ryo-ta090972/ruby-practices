# frozen_string_literal: true

class Formatter
  COLUMN = 3
  SPACE = 8

  def initialize(show_all, reverse_order, show_long_format)
    @show_all = show_all
    @reverse_order = reverse_order
    @show_long_format = show_long_format
  end

  def format(directory, paths)
    target_files = @show_all ? directory.files : directory.files.reject { |file| file.name.start_with?('.') }
    sorted_files = @reverse_order ? target_files.reverse : target_files
    max_sizes = directory.find_max_size_of_file_details(sorted_files)
    formatter_files = @show_long_format ? long_format(sorted_files, max_sizes) : short_format(sorted_files, max_sizes)
    multiple?(paths) ? ["#{directory.path}:", formatter_files].join("\n") : formatter_files
  end

  private

  def long_format(files, max_sizes)
    file_details = build_file_details(files, max_sizes)
    total_block_size = files.sum(&:block_size)
    ["total #{total_block_size}", file_details].join("\n")
  end

  def build_file_details(files, max_sizes)
    files.map do |file|
      [
        file.type_and_permission.ljust(max_sizes[:type_and_permission] + 1),
        file.nlink.to_s.rjust(max_sizes[:nlink]),
        file.uid.ljust(max_sizes[:uid] + 1),
        file.gid.ljust(max_sizes[:gid] + 1),
        file.size.to_s.rjust(max_sizes[:size]),
        file.mtime.strftime('%_m %e %H:%M'),
        "#{file.name}\n"
      ].join(' ')
    end.join
  end

  def short_format(files, max_sizes)
    file_names = files.map(&:name)
    row = cal_row(file_names)
    max_size = max_sizes[:name]
    width = cal_width(max_size)
    transposed_file_names = transpose_file_names(file_names, row)
    format_names(transposed_file_names, width)
  end

  def cal_row(file_names)
    (file_names.size.to_f / COLUMN).ceil
  end

  def cal_width(max_size)
    if (max_size % SPACE).zero?
      (max_size.to_f / SPACE + 1).ceil * SPACE
    else
      (max_size.to_f / SPACE).ceil * SPACE
    end
  end

  def transpose_file_names(file_names, row)
    file_names.each_slice(row).map do |sliced_file_names|
      sliced_file_names.values_at(0...row)
    end.transpose
  end

  def format_names(rows_file_names, width)
    rows_file_names.map do |row_file_names|
      row_file_names.each_with_index.map do |file_name, column|
        last?(row_file_names, column) ? "#{file_name}\n" : file_name.to_s.ljust(width)
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
