require './frame'

class Game
    attr_reader :frames
  
    def initialize(score)
      create_frames(score)
    end
  
    def create_frames(score)
      scores = []
      scores_split = score.split(',')
      scores_split.each do |score|
        if score == 'X'
          scores.push(10,0)
        else
          scores.push(score.to_i)
        end
      end
      scores = scores.each_slice(2).map {|arr| arr }
      p scores
      @frames = scores.map { |frame| Frame.new(frame[0], frame[1]) }
    end

  def display_total_score
    
    total_score = 0

    @frames.each_with_index do |frame, i|
      next if i == 10
      if frame.strike? && @frames[i + 1].strike?
       total_score = total_score + @frames[i].score + @frames[i + 1].score + @frames[i + 2].first_shot.score
      elsif frame.strike?
       total_score = total_score + @frames[i].score + @frames[i + 1].score
      elsif frame.spare?
       total_score = total_score + @frames[i].score + @frames[i + 1].first_shot.score
      else
       total_score = total_score + @frames[i].score
      end
    end
    p total_score
  end
end

p Game.new(ARGV[0]).display_total_score