require 'optparse'
require_relative 'no_option_output'
require_relative 'l_option_output'

class Main

  def initialize
    @option = ARGV.getopts('arl')
    input
  end

  def input
    a = @option['a'] == true ? File::FNM_DOTMATCH : 0
    files = Dir.glob('*',a)
    main(files) 
  end

  def main(files)
    if @option['l'] == true
      LOptionOutput.new(files)
    else
      NoOptionOutput.new(files)
    end
  end

end

Main.new
