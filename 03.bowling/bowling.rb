# frozen_string_literal: true

STRIKE = 10
SPARE = 10

data = ARGV[0]
down_pins = data.split(',')
scores = []
down_pins.each do |down_pin|
  if down_pin == 'X'
    scores << STRIKE
    scores << 0
  else
    scores << down_pin.to_i
  end
end

frames = scores.each_slice(2).to_a

total_score = 0
10.times do |index|
  total_score += frames[index].sum

  if frames[index][0] == STRIKE && frames[index + 1][0] == STRIKE
    total_score += frames[index + 1][0] + frames[index + 2][0]
  elsif frames[index][0] == STRIKE && frames[index + 1][0] != STRIKE
    total_score += frames[index + 1].sum
  elsif frames[index].sum == SPARE
    total_score += frames[index + 1][0]
  end
end

p total_score
