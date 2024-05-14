# frozen_string_literal: true

class ShortFormat
  COLUMN = 3
  WIDTH = 22

  def initialize(entry_groups)
    @entry_groups = entry_groups
  end

  def execute
    repositioned_entry_groups = reposition_entry_groups
    convert_output_string(repositioned_entry_groups)
  end

  private

  def reposition_entry_groups
    @entry_groups.transform_values do |group_entries|
      path = @entry_groups.key(group_entries)

      transposed_group_entries = group_entries.each_slice(rows[path]).map do |entries|
        entries.values_at(0...rows[path])
      end.transpose
      transposed_group_entries.map(&:compact)
    end
  end

  def rows
    @entry_groups.transform_values do |group_entries|
      (group_entries.size.to_f / COLUMN).ceil
    end
  end

  def convert_output_string(entry_groups)
    entry_groups.each_with_object([]) do |(path, group_entries), output_strings|
      output_strings << "#{path}:\n" if !entry_groups.one?

      group_entries.each do |entries|
        entries.each_with_index do |entry, index|
          output_strings << if last?(entries, index)
                              "#{entry}\n"
                            else
                              "#{entry.to_s.ljust(WIDTH)}  "
                            end
        end
      end
      output_strings << "\n"
    end.join.rstrip
  end

  def last?(entries, index)
    index == entries.size - 1
  end
end
