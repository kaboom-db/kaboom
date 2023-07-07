class ReadIssue < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :issue
  has_one :comic, through: :issue

  # Validations
  validates_presence_of :read_at
end
