require "ostruct"

class RatingPresenter
  attr_reader :rateable, :current_user

  def initialize(rateable:, current_user: nil)
    @rateable = rateable
    @current_user = current_user
  end

  def user_rating
    @user_rating ||= current_user&.ratings&.find_by(rateable:)&.score || 0
  end

  def average_rating
    return @average_rating if @average_rating
    ratings = rateable.ratings
    num_of_ratings = ratings.load.count.to_f
    return 0 if num_of_ratings == 0
    sum_of_ratings = ratings.sum(&:score)
    @average_rating = sum_of_ratings / num_of_ratings
  end

  def top_reviews
    return @top_reviews if @top_reviews
    reviews = Review.where(reviewable: rateable).order(created_at: :desc).limit(3).to_a
    # Ensure that 3 items are always returned
    @top_reviews = 3.times.map do |index|
      reviews[index]
    end
  end
end
