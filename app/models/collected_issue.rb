class CollectedIssue < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :issue
  has_one :comic, through: :issue

  # Validations
  validates :issue_id, uniqueness: {scope: :user_id}

  def social_class = Social::CollectedActivity
end
