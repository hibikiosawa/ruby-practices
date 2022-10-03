# frozen_string_literal: true

class ShortOptionOutput
  def initialize(files)
    @files = files
  end

  def print_data
    files_output = ((@files.size + 1).to_f / 3).ceil
    files_output.times do |row|
      col = 0
      3.times do
        print "#{@files[row + col]} ".ljust(25)
        col += files_output
      end
      puts
    end
  end
end
