# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []
i = 0
count = 0

scores.each do |s|
  shots << if s == 'X'
             10
           else
             s.to_i
           end
end

while count < 10
  if count == 10
    # 10フレーム目
    if shots[i] + shots[i + 2] == 10
      shots[i] + shots[i + 2] + shots[i + 3]
    else
      shots[i] + shots[i + 2]
    end
  elsif shots[i] == 10
    # ストライクの場合
    total = total.to_i + shots[i] + shots[i + 1] + shots[i + 2]
    count += 1
    i += 1
  elsif shots[i] + shots[i + 1] == 10 || shots[i - 1] == 10 && shots[i] + shots[i + 1] == 10
    # スペアか２回連続ストライクの場合
    total = total.to_i + shots[i] + shots[i + 1] + shots[i + 2]
    count += 1
    i += 2
  else
    # 通常の場合
    total = total.to_i + shots[i] + shots[i + 1]
    count += 1
    i += 2
  end
end

puts total
