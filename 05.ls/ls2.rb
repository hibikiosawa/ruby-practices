# frozen_string_literal: true

require 'optparse'
require 'etc'

opt = OptionParser.new
args = {}
opt.on('-l') { |v| args[:l] = v }
opt.parse!(ARGV)

def input(_args)
  Dir.glob('*')
end

def count(arr)
  nlinkmax = 0
  sizemax = 0
  files = arr.size
  files.times do |row|
    fs = File::Stat.new(arr[row])
    nlinkmax = fs.nlink if nlinkmax < fs.nlink
    sizemax = fs.size if sizemax < fs.size
  end
  @nlinkmax = nlinkmax.to_s.length + 1
  @sizemax = sizemax.to_s.length + 1
end

def file_convert(fil)
  file = {
    '010' => 'p',
    '020' => 'c',
    '040' => 'd',
    '060' => 'b',
    '100' => '-',
    '120' => 'l',
    '140' => 's'
  }
  print file[fil]
end

def permission_convert(pem)
  permission = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }
  print permission[pem]
end

def l_option_output(arr)
  print "合計#{arr.size} \n"
  files = arr.size
  files.times do |row|
    fs = File.lstat(arr[row])
    file_convert(format('%06d', fs.mode.to_s(8)).slice(0..2))
    (3..6).each do |i|
      permission_convert(format('%06d', fs.mode.to_s(8)).slice(i))
    end
    user = Etc.getpwuid(fs.uid).name
    group = Etc.getgrgid(fs.gid).name
    print " #{fs.nlink}".rjust(@nlinkmax)
    print " #{user} #{group}"
    print " #{fs.size}".rjust(@sizemax)
    filedate = fs.atime
    print " #{filedate.strftime('%-m月')}"
    print " #{filedate.strftime('%d')}".rjust(2)
    print " #{filedate.strftime('%H:%M')} #{filedate.strftime('%Y')} #{arr[row]}"
    if fs.symlink?
      (symlink = File.readlink(arr[row])
       print(" -> #{symlink}"))
    end
    print "\n"
  end
end

def output(arr)
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

arr = input(args)
count(arr)

if args[:l]
  l_option_output(arr)
else
  output(arr)
end
