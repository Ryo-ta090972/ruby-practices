# frozen_string_literal: true

class Game
  def initialize(first_frame, second_frame, third_frame, fourth_frame, fifth_frame, sixth_frame, seventh_frame, eighth_frame, ninth_frame, tenth_frame)
    @first_frame = Frame.new(first_frame)
    @second_frame = Frame.new(second_frame)
    @third_frame = Frame.new(third_frame)
    @fourth_frame = Frame.new(fourth_frame)
    @fifth_frame = Frame.new(fifth_frame)
    @sixth_frame = Frame.new(sixth_frame)
    @seventh_frame = Frame.new(seventh_frame)
    @eighth_frame = Frame.new(eighth_frame)
    @ninth_frame = Frame.new(ninth_frame)
    @tenth_frame = Frame.new(tenth_frame)
  end
end
