# frozen_string_literal: true

require './score'
require './game'

score = Score.new
game = Game.new(*score.frames)
puts game.score
