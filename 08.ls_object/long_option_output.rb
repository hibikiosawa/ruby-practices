# frozen_string_literal: true

require 'etc'
class LongOptionOutput
  def initialize(files)
    @files = files
  end

  def main
    @files.size.times do |row|
      nlinkmax, sizemax = word_length(@files)
      fs = File.lstat(@files[row])
      file_type = file_convert_output(fs.ftype)
      file_permission = permission_convert_output(fs.mode)
      user = Etc.getpwuid(fs.uid).name
      group = Etc.getgrgid(fs.gid).name
      nlink = fs.nlink.to_s.rjust(nlinkmax.to_s.size)
      file_size = fs.size.to_s.rjust(sizemax.to_s.size)
      file_created = fs.atime.strftime('%-m月 %d %H:%M %Y')
      print "#{file_type}#{file_permission} #{nlink} #{user} #{group} #{file_size} #{file_created} #{@files[row]}"
      print(" -> #{File.readlink(files[row])}") if fs.symlink?
      puts
    end
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
