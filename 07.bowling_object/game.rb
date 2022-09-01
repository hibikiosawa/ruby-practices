
require_relative 'frame'
require_relative 'shot'


class Game

  def initialize
    @marks
  end
  
  def frame
    frame = Frame.new(@scores[0,1])
    p frame.score
  end

end

game = Game.new(ARGV[0])