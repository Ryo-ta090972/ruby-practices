# frozen_string_literal: true

require 'etc'

class FileDetail
  attr_reader :name

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

  BLOCK_SIZE = 4096
  BLOCK = 8

  def initialize(name, path)
    @path = File.absolute_path(name, path)
    @name = name
    @file_stat = File::Stat.new(@path)
  end

  def type_and_permission
    type + permission
  end

  def nlink
    @file_stat.nlink
  end

  def uid
    Etc.getpwuid(@file_stat.uid).name
  end

  def gid
    Etc.getgrgid(@file_stat.gid).name
  end

  def size
    @file_stat.size
  end

  def mtime
    @file_stat.mtime
  end

  def block_size
    @file_stat.directory? ? 0 : (size.to_f / BLOCK_SIZE).ceil * BLOCK
  end

  private

  def type
    type_number = file_number[0, 2]
    FILE_TYPE[type_number]
  end

  def permission
    permission_number = file_number[3, 3]
    permission = permission_number.gsub(/./, PERMISSION)
    authority? ? to_authority(permission) : permission
  end

  def file_number
    @file_stat.mode.to_s(8).rjust(6, '0')
  end

  def authority_number
    file_number[2, 1]
  end

  def authority?
    AUTHORITY_INDEX.key?(authority_number)
  end

  def to_authority(permission)
    authority_permission = permission.dup
    index = AUTHORITY_INDEX[authority_number]
    authority_permission[index] = AUTHORITY_TYPE[authority_number][authority_permission[index]]
    authority_permission
  end
end
