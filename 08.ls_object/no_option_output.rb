# frozen_string_literal: true

class NoOptionOutput
  def initialize(files)
    @files = files
    main
  end

  def main
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
