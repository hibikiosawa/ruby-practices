# frozen_string_literal: true

require 'optparse'
require 'etc'

def main
  files_input = ARGV[0]
  files = input(files_input)
  commandline_judge(files_input)
end

def commandline_judge(files)
  no_option_output(files)
end

def input(files_input)
  Dir.glob(files_input)
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

def count_lines(file)
  file.lines.count
end

def count_words(file)
  ary = file.split(/\s+/)
  ary.size
end


def no_option_output(files_input)
  file = File.read(files_input)
  print "#{count_lines(file)} #{count_words(file)} #{file.size}"
end

main
