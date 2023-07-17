class CollectedIssue < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :issue

  # Validations
  validates :issue_id, uniqueness: {scope: :user_id}
end
