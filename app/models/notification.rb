class Notification < ApplicationRecord
  TYPES = [
    NEW_ISSUE = "new_issue"
  ]

  NOTIFIABLES = [
    "Issue",
    "User"
  ]

  # associations
  belongs_to :user
  belongs_to :notifiable, polymorphic: true, optional: true

  # validations
  validates_inclusion_of :notification_type, in: TYPES
  validates_inclusion_of :notifiable_type, in: NOTIFIABLES, allow_nil: true
end
