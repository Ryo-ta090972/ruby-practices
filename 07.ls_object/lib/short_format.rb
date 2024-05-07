# frozen_string_literal: true

class ShortFormat
  COLUMN = 3
  WIDTH = 22

  def initialize(entry_groups)
    @entry_groups = entry_groups
  end

  def execute
    repositioned_entry_groups = reposition_entry_groups
    formatted_entry_groups = format_entry_groups(repositioned_entry_groups)
    convert_output_string(formatted_entry_groups)
  end

  private

  def reposition_entry_groups
    @entry_groups.each_with_object({}) do |(path, group_entries), repositioned_entry_groups|
      transposed_entries = group_entries.each_slice(rows[path]).map do |entries|
        entries.values_at(0...rows[path])
      end.transpose
      repositioned_entry_groups[path] = transposed_entries
    end
  end

  def rows
    @entry_groups.each_with_object({}) do |(path, group_entries), rows|
      rows[path] = (group_entries.size.to_f / COLUMN).ceil
    end
  end

  def format_entry_groups(entry_groups)
    entry_groups.each_with_object({}) do |(path, group_entries), short_format_entries|
      left_justified_group_entries = group_entries.map do |entries|
        entries.map do |entry|
          "#{entry.to_s.ljust(WIDTH)}  "
        end
      end
      short_format_entries[path] = left_justified_group_entries
    end
  end

  def convert_output_string(entry_groups)
    entry_groups.each_with_object([]) do |(path, group_entries), output_strings|
      output_strings << "#{path.to_s}:\n" if !entry_groups.one?
      group_entries.each do |entries|
        entries.each_with_index do |entry, index|
          output_string = last?(entries, index) ? entry.rstrip : entry
          output_strings << output_string
        end
        output_strings << "\n"
      end
      output_strings << "\n"
    end.join.rstrip
  end

  def last?(entries, index)
    index == entries.size - 1
  end
end
