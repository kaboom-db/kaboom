# frozen_string_literal: true

class StarRatingComponent < ViewComponent::Base
  def initialize(current_user:, rate_url:, rating: 0)
    @current_user = current_user
    @rate_url = rate_url
    @rating = rating
  end

  def render?
    @current_user.present?
  end
end
