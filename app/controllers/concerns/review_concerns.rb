# frozen_string_literal: true

module ReviewConcerns
  extend ActiveSupport::Concern

  def reviews
    @reviews = @resource.reviews.includes(:user).where(user: {private: false})
    @resource_path = [@resource.respond_to?(:comic) ? @resource.comic : nil, @resource]
    @rating_presenter = RatingPresenter.new(resource: @resource, current_user:)
    render "pages/reviews"
  end
end
