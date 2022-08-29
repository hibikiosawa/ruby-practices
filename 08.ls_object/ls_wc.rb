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
    next unless files.size > 1

    lines_size += count_lines(file_readed)
    words_size += count_words(file_readed)
    files_size += file_readed.size
  end
  [lines_size, words_size, files_size]
end

def output(files, option)
  files.each do |file|
    file_readed = File.read(file)
    print "#{count_lines(file_readed)} " if option['l']
    print "#{count_words(file_readed)} " if option['w']
    print "#{file_readed.size} " if option['c']
    print count_lines(file_readed).to_s.rjust(8)
    print count_words(file_readed).to_s.rjust(8)
    print file_readed.size.to_s.rjust(8)
    print " #{file} \n" if option['l'] == false && option['w'] == false && option['c'] == false
  end
  lines_size, words_size, files_size = files_line_word_total_count(files)
  print lines_size.to_s.rjust(8)
  print words_size.to_s.rjust(8)
  print files_size.to_s.rjust(8)
  print " total \n" if files.size > 1
end

main
