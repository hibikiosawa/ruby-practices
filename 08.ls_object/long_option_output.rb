# frozen_string_literal: true

require 'etc'
class LongOptionOutput
  def initialize(files)
    @files = files
  end

  def print_data
    @files.size.times do |row|
      nlinkmax, sizemax = word_length(@files)
      file_status = File.lstat(@files[row])
      create_file_data(file_status, nlinkmax, sizemax)
      print "#{@file_type}#{@file_permission} #{@nlink} #{@user} #{@group} #{@file_size} #{@file_created} #{@files[row]} #{@symlink}"
      puts
    end
  end

  def create_file_data(file_status, nlinkmax, sizemax)
    @file_type = file_convert_output(file_status.ftype)
    @file_permission = permission_convert_output(file_status.mode)
    @user = Etc.getpwuid(file_status.uid).name
    @group = Etc.getgrgid(file_status.gid).name
    @nlink = file_status.nlink.to_s.rjust(nlinkmax.to_s.size)
    @file_size = file_status.size.to_s.rjust(sizemax.to_s.size)
    @file_created = file_status.atime.strftime('%-m月 %d %H:%M %Y')
    @symlink = " -> #{File.readlink(files[row])}" if file_status.symlink?
  end

  def word_length(files)
    nlinkmax = 0
    sizemax = 0
    files.size.times do |row|
      fs = File::Stat.new(files[row])
      nlinkmax = fs.nlink if nlinkmax < fs.nlink
      sizemax = fs.size if sizemax < fs.size
    end
    [nlinkmax, sizemax]
  end

  def file_convert_output(file)
    file_permission = {
      'characterSpecial' => 'c', 'directory' => 'd', 'blockSpecial' => 'b', 'file' => '-', 'link' => 'l', 'socket' => 's'
    }
    file_permission[file]
  end

  def permission_convert_output(pem)
    per = []
    permission = { '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-',
                   '7' => 'rwx' }
    (3..5).each do |i|
      per << permission[(format('%06d', pem.to_s(8)).slice(i))]
    end
    per.join
  end
end
