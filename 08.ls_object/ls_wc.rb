# frozen_string_literal: true

require 'optparse'
require 'etc'

def main
  option = ARGV.getopts('lwc')
  files_input = ARGV
  files = input(files_input)
  output(files, option)
end

def input(files_input)
  if files_input.empty?
    Dir.glob('*')
  else
    Dir.glob(files_input)
  end
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

def files_line_word_total_count(files)
  lines_size = 0
  words_size = 0
  files_size = 0
  files.each do |file|
    file_readed = File.read(file)
    if files.size > 1
      lines_size += count_lines(file_readed)
      words_size += count_words(file_readed)
      files_size += file_readed.size
    end
  end
  [lines_size, words_size, files_size]
end

def output(files,option)
  files.each do |file|
    file_readed = File.read(file)
    print "#{count_lines(file_readed)} " if option['l']
    print "#{count_words(file_readed)} " if option['w']
    print "#{file_readed.size} " if option['c']

    if option["l"] == false && option["w"] == false && option["c"] == false 
      print "#{count_lines(file_readed)}".rjust(8)
      print "#{count_words(file_readed)}".rjust(8)
      print "#{file_readed.size}".rjust(8)
    end
    print " #{file} \n"
  end
  if files.size > 1
    lines_size, words_size, files_size = files_line_word_total_count(files)
    print "#{lines_size}".rjust(8)
    print "#{words_size}".rjust(8)
    print "#{files_size}".rjust(8)
    print " total \n"
  end
end

main
