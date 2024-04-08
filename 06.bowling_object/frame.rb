# frozen_string_literal: true

class frame
  def initialize(first_mark, second_mark, third_mark = nil)
    @first_mark = Shot.new(first_mark)
    @second_mark = Shot.new(second_mark)
    @third_mark = Shot.new(third_mark)
  end
end