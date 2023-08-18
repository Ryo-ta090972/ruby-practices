# frozen_string_literal: true

data = ARGV[0]
down_pin = data.split(',')
scores = []
down_pin.each do |s|
  if s == 'X'
    scores << 10
    scores << 0
  else
    scores << s.to_i
  end
end

frames = []
scores.each_slice(2) do |s|
  frames << s
end

total_score = 0
frames.each_with_index do |frame, index|
  next unless index < 10

  total_score += if frame[0] == 10 && frames[index + 1][0] == 10
                   10 + frames[index + 1][0] + frames[index + 2][0]
                 elsif frame[0] == 10 && frames[index + 1][0] != 10
                   10 + frames[index + 1].sum
                 elsif frame.sum == 10
                   10 + frames[index + 1][0]
                 else
                   frame.sum
                 end
end

p total_score
