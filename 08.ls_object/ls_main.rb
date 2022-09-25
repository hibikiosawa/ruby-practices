# frozen_string_literal: true

require 'optparse'
require_relative 'long_option_output'
require_relative 'short_option_output'

class Main
  def initialize
    @option = ARGV.getopts('arl')
  end

  def input_files(option_a)
    files = Dir.glob('*', option_a)
  end

  def option_judge
    option_a = @option['a'] == true ? File::FNM_DOTMATCH : 0
    if @option['l'] == true
      LongOptionOutput.new(input_files(option_a))
    else
      ShortOptionOutput.new(input_files(option_a))
    end
  end
end

ls = Main.new
ls.option_judge
