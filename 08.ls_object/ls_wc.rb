# frozen_string_literal: true

require 'optparse'
require 'etc'

def main
  files_input = open(ARGV[0])
  files = input(files_input)
  commandline_judge(files)
end

def commandline_judge(files)
  no_option_output(files)
end

def input(files_input)
  Dir.glob('files_input')
  p files_input
end

def word_length(files)
  size_max = 0
  files.size.times do |row|
    fs = File::Stat.new(files[row])
    nlinkmax = fs.nlink if nlinkmax < fs.nlink
    sizemax = fs.size if sizemax < fs.size
  end
  nlinkmax = nlinkmax.to_s.length
  sizemax = sizemax.to_s.length
  [nlinkmax, sizemax]
end

def no_option_output(files)
line_count = 0
  while files.gets
    line_count += 1
  end
  print "#{line_count} #{files.size}"
end

main
