# frozen_string_literal: true

class RatingSectionComponent < ViewComponent::Base
  def initialize(rating_presenter:)
    @rating_presenter = rating_presenter
  end
end
