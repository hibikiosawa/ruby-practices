# frozen_string_literal: true

require 'optparse'
require 'etc'

def main
  option = ARGV.getopts('lwc')
  files_input = ARGV[0]
  files = input(files_input)
  output(files_input, option)
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


def output(files_input,option)
  file = File.read(files_input)
  print "#{count_lines(file)} " if option['l']
  print "#{count_words(file)} " if option['w']
  print "#{file.size} " if option['c']

  if option[:l].nil? && option[:w].nil? && option[:c].nil?
    print "#{count_lines(file)} #{count_words(file)} #{file.size} "
  end
  print "#{files_input} \n"
end

main
