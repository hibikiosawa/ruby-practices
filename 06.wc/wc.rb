# frozen_string_literal: true

require 'optparse'
require 'etc'

def main
  option = ARGV.getopts('lwc')
  files_input = ARGV
  if File.pipe?($stdin)
    stdin = $stdin.read
    output_stdin(stdin, option)
  else
    files = input(files_input)
    output_standard(files, option)
  end
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

def output_total(files, option)
  lines_size, words_size, files_size = files_line_word_total_count(files)
  print lines_size.to_s.rjust(8) if option['l']
  print words_size.to_s.rjust(8) if option['w']
  print files_size.to_s.rjust(8) if option['c']
  if option['l'] == false && option['w'] == false && option['c'] == false
    print lines_size.to_s.rjust(8)
    print words_size.to_s.rjust(8)
    print files_size.to_s.rjust(8)
  end
  print " total \n" if files.size > 1
end

def output_file_info(file_readed, file, option)
  print count_lines(file_readed).to_s.rjust(8) if option['l']
  print count_words(file_readed).to_s.rjust(8) if option['w']
  print file_readed.size.to_s.rjust(8) if option['c']
  if option['l'] == false && option['w'] == false && option['c'] == false
    print count_lines(file_readed).to_s.rjust(8)
    print count_words(file_readed).to_s.rjust(8)
    print file_readed.size.to_s.rjust(8)
  end
  print " #{file} \n"
end

def output_standard(files, option)
  files.each do |file|
    file_readed = File.read(file)
    output_file_info(file_readed, file, option)
  end
  output_total(files, option) if files.size > 1
end

def output_stdin(stdin, option)
  print "#{count_lines(stdin)} " if option['l']
  print "#{count_words(stdin)} " if option['w']
  print "#{stdin.size} " if option['c']
  print count_lines(stdin).to_s.rjust(8)
  print count_words(stdin).to_s.rjust(8)
  print stdin.size.to_s.rjust(8)
  print "\n"
end

main
