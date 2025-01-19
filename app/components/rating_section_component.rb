# frozen_string_literal: true

class RatingSectionComponent < ViewComponent::Base
  def initialize(rating_presenter:, reviews_path:)
    @rating_presenter = rating_presenter
    @reviews_path = reviews_path
  end
end
