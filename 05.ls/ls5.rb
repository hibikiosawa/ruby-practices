# frozen_string_literal: true

require 'optparse'
require 'etc'

def main
  option = ARGV.getopts('arl')
  date_array = input(option)
  commandline_judge(date_array, option)
end

def commandline_judge(date_array, option)
  date_array.reverse! if option['r']
  if option['l']
    print "合計#{date_array.size} \n"
    date_array.size.times do |row|
      l_option_output(date_array, row)
      print "\n"
    end
  else
    no_option_output(date_array)
  end
end

def input(option)
  a = option[:a].nil? ? 0 : File::FNM_DOTMATCH
  Dir.glob('*', a)
end

def word_length(date_array)
  nlinkmax = 0
  sizemax = 0
  date_array.size.times do |row|
    fs = File::Stat.new(date_array[row])
    nlinkmax = fs.nlink if nlinkmax < fs.nlink
    sizemax = fs.size if sizemax < fs.size
  end
  nlinkmax = nlinkmax.to_s.length
  sizemax = sizemax.to_s.length
  [nlinkmax, sizemax]
end

def file_convert_output(fil)
  file = {
    '010' => 'p', '020' => 'c', '040' => 'd', '060' => 'b', '100' => '-', '120' => 'l', '140' => 's'
  }
  print file[format('%06d', fil.to_s(8)).slice(0..2)]
end

def permission_convert_output(pem)
  permission = { '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-',
                 '7' => 'rwx' }
  (3..6).each do |i|
    print permission[(format('%06d', pem.to_s(8)).slice(i))]
  end
end

def l_option_output(date_array, row)
  nlinkmax, sizemax = word_length(date_array)
  fs = File.lstat(date_array[row])
  file_convert_output(fs.mode)
  permission_convert_output(fs.mode)
  user = Etc.getpwuid(fs.uid).name
  group = Etc.getgrgid(fs.gid).name
  nlink = fs.nlink.to_s.rjust(nlinkmax.to_i)
  filesize = fs.size.to_s.rjust(sizemax)
  file = fs.atime.strftime('%-m月 %d %H:%M %Y')
  print " #{nlink} #{user} #{group} #{filesize} #{file} #{date_array[row]}"
  print(" -> #{File.readlink(date_array[row])}") if fs.symlink?
end

def no_option_output(date_array)
  files = ((date_array.size + 1).to_f / 3).ceil
  files.times do |row|
    col = 0
    3.times do
      print "#{date_array[row + col]} ".ljust(25)
      col += files
    end
    puts "\n"
  end
end

main
