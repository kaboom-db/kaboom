# frozen_string_literal: true

class Svg::RatingCircleComponent < ViewComponent::Base
  RADIUS = 200

  def initialize(rating:, multiplier: 1, classes: "")
    @radius = RADIUS * multiplier
    @rating = [rating * 10, 100].min.round.to_f
    @circumfrence = @radius * 2 * Math::PI
    @percent_as_circle = (100 - @rating) / 100 * @circumfrence
    @dimensions = @radius + 15
    @viewport = @dimensions * 2
    @colour = colour
    @classes = classes
  end

  def colour
    red = "#f6504b"
    yellow = "#e0ca3c"
    green = "#00df77"
    return red if @rating < 100 / 3
    return yellow if @rating < 200 / 3
    green
  end
end
