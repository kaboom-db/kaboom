# frozen_string_literal: true

class RatingPresenter
  attr_reader :resource, :current_user

  def initialize(resource:, current_user: nil)
    @resource = resource
    @current_user = current_user
  end

  def user_rating
    @user_rating ||= current_user&.ratings&.find_by(rateable: resource)&.score || 0
  end

  def average_rating
    return @average_rating if @average_rating

    ratings = resource.ratings
    num_of_ratings = ratings.load.count.to_f
    return 0 if num_of_ratings == 0
    sum_of_ratings = ratings.sum(&:score)
    @average_rating = (sum_of_ratings / num_of_ratings).round(2)
  end

  def top_reviews
    return @top_reviews if @top_reviews

    reviews = Review.where(reviewable: resource).order(created_at: :desc).limit(3).to_a
    # Ensure that 3 items are always returned
    @top_reviews = 3.times.map do |index|
      reviews[index]
    end
  end
end
