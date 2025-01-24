# frozen_string_literal: true

module RatingConcerns
  extend ActiveSupport::Concern

  def rate
    rating = Rating.find_or_initialize_by(user: current_user, rateable: @resource)
    if rating.update(score: params[:rating])
      render json: {success: true}
    else
      render json: {success: false}, status: 422
    end
  end
end
