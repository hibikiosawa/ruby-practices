# frozen_string_literal: true

require 'optparse'
require_relative 'long_option_output'
require_relative 'short_option_output'

class Main
  def initialize
    @option = ARGV.getopts('arl')
  end

  def input_files(option_a)
    Dir.glob('*', option_a)
  end

  def option_judge
    option_a = @option['a'] == true ? File::FNM_DOTMATCH : 0
    if @option['l'] == true
      output_option = LongOptionOutput.new((input_files(option_a)))
      output_option = LongOptionOutput.new(input_files(option_a).reverse!) if @option['r'] == true
    else
      output_option = ShortOptionOutput.new((input_files(option_a)))
      output_option = ShortOptionOutput.new((input_files(option_a).reverse!)) if @option['r'] == true
    end
    output_option.print_data
  end
end

ls = Main.new
ls.option_judge
