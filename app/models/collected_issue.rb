class CollectedIssue < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :issue
  has_one :comic, through: :issue

  # Validations
  validates :issue_id, uniqueness: {scope: :user_id}
  validates :price_paid, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 100_000}

  def social_class = Social::CollectedActivity
end
