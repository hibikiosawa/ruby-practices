# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot

  MAX_SCORE = 10

  def initialize(first_mark, second_mark)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
  end

  def score
    [@first_shot.score, @second_shot.score].sum
  end

  def strike?
    @first_shot.score == MAX_SCORE
  end

  def spare?
    [@first_shot.score, @second_shot.score].sum == MAX_SCORE
  end
end
