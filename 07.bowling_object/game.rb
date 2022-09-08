# frozen_string_literal: true

require './frame'

class Game
  attr_reader :frames

  def initialize(score)
    create_frames(score)
  end

  def create_frames(score)
    scores = []
    scores_split = score.split(',')
    scores_split.each do |s|
      if s == 'X'
        scores.push(10, 0)
      else
        scores.push(s.to_i)
      end
    end
    scores = scores.each_slice(2).map { |arr| arr }
    @frames = scores.map { |frame| Frame.new(frame[0], frame[1]) }
  end

  def display_total_score
    total_score = 0

    @frames.each_with_index do |frame, i|
      next if i == 10

      total_score = if frame.strike? && @frames[i + 1].strike?
                      total_score + @frames[i].score + @frames[i + 1].score + @frames[i + 2].first_shot.score
                    elsif frame.strike?
                      total_score + @frames[i].score + @frames[i + 1].score
                    elsif frame.spare?
                      total_score + @frames[i].score + @frames[i + 1].first_shot.score
                    else
                      total_score + @frames[i].score
                    end
    end
    puts total_score
  end
end

Game.new(ARGV[0]).display_total_score
