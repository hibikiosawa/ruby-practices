# frozen_string_literal: true

require 'etc'
class LongOptionOutput
  def initialize(files)
    @files = files
  end

  def print_data
    print "合計#{@files.size} \n"
    @files.size.times do |row|
      nlinkmax, sizemax = word_length(@files)
      file_status = File.lstat(@files[row])
      dates = create_file_data(file_status, nlinkmax, sizemax,row)
      print dates
      puts
    end
  end

  def create_file_data(file_status, nlinkmax, sizemax,row)
    symlink = " -> #{File.readlink(@files[row])}" if file_status.symlink?
    dates =
    [
    "#{file_convert_output(file_status.ftype)}",
    "#{permission_convert_output(file_status.mode)}",
    " #{Etc.getpwuid(file_status.uid).name}",
    " #{Etc.getgrgid(file_status.gid).name}",
    " #{file_status.nlink.to_s.rjust(nlinkmax.to_s.size)}",
    " #{file_status.size.to_s.rjust(sizemax.to_s.size)}",
    " #{file_status.atime.strftime('%m月 %d %H:%M %Y')}",
    " #{symlink}"
  ].join
  end

  def word_length(files)
    stats = files.map { |file| File::Stat.new(file) }
    nlinkmax = stats.map(&:nlink).max
    sizemax = stats.map(&:size).max
    [nlinkmax, sizemax]
  end

  def file_convert_output(file)
    file_permission = {
      character_special:'c', directory:'d', block_special:'b', file:'-', link:'l', socket:'s'
    }
    file_permission[:file]
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
