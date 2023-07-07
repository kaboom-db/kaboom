class ReadIssue < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :issue

  # Validations
  validates_presence_of :read_at
end
