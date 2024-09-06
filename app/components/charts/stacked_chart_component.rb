# frozen_string_literal: true

class Charts::StackedChartComponent < ViewComponent::Base
  def initialize(data:, title:, type:)
    @data = data
    @title = title
    @type = type
    @colours = Charts::Colours.new
  end

  def render?
    @data.any?
  end

  private

  def strip_float(number:)
    i = number.to_i
    f = number.to_f
    (i != f) ? f : i
  end
end
