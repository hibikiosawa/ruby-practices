# frozen_string_literal: true
require 'optparse'
require 'etc'

opt = OptionParser.new
args = {}
opt.on('-l') {|v| args[:l] = v}
opt.parse!(ARGV)

def input(_args)
  Dir.glob("*")
end

def count(arr)
  nlinkmax = 0
  sizemax = 0
  files = arr.size
  files.times do |row|
    fs = File::Stat.new(arr[row])
    if nlinkmax < fs.nlink
      nlinkmax = fs.nlink
    end
    if sizemax < fs.size
      sizemax = fs.size
    end
  end
  @nlinkmax = nlinkmax.to_s.length + 1
  @sizemax = sizemax.to_s.length + 1
end

def output(arr,args)

if args[:l]
  print "合計#{arr.size} \n"
  files = arr.size
  files.times do |row|
    fs = File::lstat(arr[row])

    case format("%06d",fs.mode.to_s(8)).slice(0..2)
    when "010" then print("p")
    when "020" then print("c")
    when "040" then print("d")
    when "060" then print("b")
    when "100" then print("-")
    when "120" then print("l")
    when "140" then print("s")
    end
    
    for i in 3..6 do
      case format("%06d",fs.mode.to_s(8)).slice(i)
      when "0" then print("---")
      when "1" then print("--x")
      when "2" then print("-w-")
      when "3" then print("-wx")
      when "4" then print("r--")
      when "5" then print("r-x")
      when "6" then print("rw-")
      when "7" then print("rwx")
      end
    end

    user = Etc.getpwuid(fs.uid).name
    group = Etc.getgrgid(fs.gid).name
    print "#{fs.nlink}".rjust(@nlinkmax)
    print " #{user} #{group}"
    print "#{fs.size}".rjust(@sizemax)
    filedate = fs.atime
    print " #{filedate.strftime("%-m月")}"
    print "#{filedate.strftime("%d")}".rjust(2)
    print " #{filedate.strftime("%H:%M")} #{filedate.strftime("%Y")} #{arr[row]}"
    (symlink = File.readlink(arr[row]); print(" -> #{symlink}")) if fs.symlink?
    print "\n"
  end
else
  files = ((arr.size + 1).to_f / 3).ceil
  files.times do |row|
    col = 0
    3.times do
      print "#{arr[row+col]} ".ljust(25)
        col += files
      end
    puts "\n"
    end
  end
end

arr = input(args)
count(arr)
output(arr,args)
