# frozen_string_literal: true

require './lib/option_base'
require 'etc'

class OptionLong < OptionBase
  FILE_TYPE = {
    '01' => 'p',
    '02' => 'c',
    '04' => 'd',
    '10' => '-',
    '12' => 'l',
    '14' => 's'
  }.freeze

  PERMISSION = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze

  AUTHORITY_INDEX = {
    '1' => 8,
    '2' => 5,
    '4' => 2
  }.freeze

  AUTHORITY_TYPE = {
    '1' => { 'x' => 't', '-' => 'T' },
    '2' => { 'x' => 's', '-' => 'S' },
    '4' => { 'x' => 's', '-' => 'S' }
  }.freeze

  BLOCK_SIZE = 8

  private

  def apply(entries, path)
    attributes = load_attributes(entries, path)
    attributes.unshift(["total #{count_total_block_size(entries, path)}"])
  end

  def load_attributes(entries, path)
    entries.map do |entry|
      entry_path = File.absolute_path(entry, path)
      file_stat = File::Stat.new(entry_path)
      [
        build_type_and_permission(file_stat),
        file_stat.nlink,
        Etc.getpwuid(file_stat.uid).name,
        Etc.getgrgid(file_stat.gid).name,
        file_stat.size,
        file_stat.mtime,
        entry
      ]
    end
  end

  def build_type_and_permission(file_stat)
    file_number = file_stat.mode.to_s(8).rjust(6, '0')
    type_number = file_number[0, 2]
    authority_number = file_number[2, 1]
    permission_number = file_number[3, 3]
    permission = permission_number.gsub(/./, PERMISSION)
    authority_or_permission = AUTHORITY_INDEX.key?(authority_number) ? to_authority(permission, authority_number) : permission
    FILE_TYPE[type_number] + authority_or_permission
  end

  def to_authority(permission, number)
    authority_permission = permission.dup
    index = AUTHORITY_INDEX[number]
    authority_permission[index] = AUTHORITY_TYPE[number][authority_permission[index]]
    authority_permission
  end

  def count_total_block_size(entries, path)
    entries.sum do |entry|
      entry_path = File.absolute_path(entry, path)
      file_stat = File::Stat.new(entry_path)
      block = file_stat.size.to_f / file_stat.blksize
      block.round.zero? ? 0 : block.ceil * BLOCK_SIZE
    end
  end
end
