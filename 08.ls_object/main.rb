require 'optparse'

class Main

  def initialize
    option = ARGV.getopts('arl')
    option_judge(option)
  end

  def option_judge(option)
    all = true if option['a'] 
    reverse = true if option['r']
    long_format = true if option['l']
  end

end

Main.new
