class Rating < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :rateable, polymorphic: true

  # Validations
  validates :user_id, uniqueness: {scope: [:rateable_id, :rateable_type]}
  validates :score, :score, numericality: {greater_than_or_equal_to: 1, less_than_or_equal_to: 10}

  def social_class = Social::RatedActivity
end
