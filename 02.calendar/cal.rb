require 'date'
require 'optparse'

date = ARGV.getopts('y:', 'm:')

y = date['y'].to_i
m = date['m'].to_i

today = Date.today

if y == 0 && m == 0
  y = today.year
  m = today.month
elsif y == 0 && m != 0
  y = today.year
end

if y < 1970 || y > 2100
  puts '1970年以降2100年以下の西暦を入力してください'
  exit
end

if m < 1 || m > 12
  puts '正しい月を入力してください'
  exit
end
puts "#{m}月#{y}年".center(20)

last = Date.new(y, m, -1)
first = Date.new(y, m, 1)

wd = first.wday

print ' 日 月 火 水 木 金 土'
print "\n"

daycount = 1

while wd > 0
  print ''.ljust(3)
  wd -= 1
end

wd = first.wday

daycount += wd

while daycount <= last.day + wd
  print "#{daycount - wd}".rjust(3)
  print "\n" if daycount % 7 == 0
  daycount += 1
end

print "\n"
