# frozen_string_literal: true
require 'debug'
class LongFormat < ShortFormat
  def initialize(entry_groups)
    @entry_groups = entry_groups
  end

  def execute
    # binding.break
    max_string_sizes_of_each_columns = cal_max_string_size_of_each_columns
    formatted_entry_groups = format_entry_groups(max_string_sizes_of_each_columns)
    convert_output_string(formatted_entry_groups)
  end

  private

  def cal_max_string_size_of_each_columns
    @entry_groups.each_with_object({}) do |(path, group_entries), max_string_sizes|
      max_string_sizes[path] = group_entries.drop(1).transpose.map do |entries|
        entries.map do |entry|
          entry.to_s.size
        end.max
      end
    end
  end

  def format_entry_groups(max_sizes)
    @entry_groups.each_with_object({}) do |(path, group_entries), formatted_entry_groups|
      formatted_entry_groups[path] = group_entries.map do |entries|
        entries.each_with_index.map do |entry, column|
          if entry.instance_of?(Integer)
            "#{entry.to_s.rjust(max_sizes[path][column])} "
          else
            "#{entry.to_s.ljust(max_sizes[path][column])}  "
          end
        end
      end
    end
  end
end
