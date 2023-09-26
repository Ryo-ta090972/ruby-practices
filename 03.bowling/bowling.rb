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
  frame = frames[index]
  next_frame = frames[index + 1]
  next_next_frame = frames[index + 2]

  bonus_score = if frame[0] == STRIKE && next_frame[0] == STRIKE
                  next_frame[0] + next_next_frame[0]
                elsif frame[0] == STRIKE && next_frame[0] != STRIKE
                  next_frame.sum
                elsif frame.sum == SPARE
                  next_frame[0]
                else
                  0
                end

  total_score += frames[index].sum + bonus_score
end

p total_score
