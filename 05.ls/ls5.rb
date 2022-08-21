# frozen_string_literal: true

require 'optparse'
require 'etc'

def main
  opt = OptionParser.new
  args = {}
  opt.on('-l') { |v| args[:l] = v }
  opt.parse!(ARGV)

  arr = input(args)
  commandline_judge(arr, args)
end

def commandline_judge(arr, args)
  if args[:l]
    print "合計#{arr.size} \n"
    arr.size.times do |row|
      l_option_output(arr, row)
      print "\n"
    end
  else
    no_option_output(arr)
  end
end

def input(_args)
  Dir.glob('*')
end

def word_length(arr)
  nlinkmax = 0
  sizemax = 0
  arr.size.times do |row|
    fs = File::Stat.new(arr[row])
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

def l_option_output(arr, row)
  nlinkmax, sizemax = word_length(arr)
  fs = File.lstat(arr[row])
  file_convert_output(fs.mode)
  permission_convert_output(fs.mode)
  user = Etc.getpwuid(fs.uid).name
  group = Etc.getgrgid(fs.gid).name
  nlink = fs.nlink.to_s.rjust(nlinkmax.to_i)
  filesize = fs.size.to_s.rjust(sizemax)
  file = fs.atime.strftime('%-m月 %d %H:%M %Y')
  print " #{nlink} #{user} #{group} #{filesize} #{file} #{arr[row]}"
  print(" -> #{File.readlink(arr[row])}") if fs.symlink?
end

def no_option_output(arr)
  files = ((arr.size + 1).to_f / 3).ceil
  files.times do |row|
    col = 0
    3.times do
      print "#{arr[row + col]} ".ljust(25)
      col += files
    end
    puts "\n"
  end
end

main
