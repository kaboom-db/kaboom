class VisitBucket < ApplicationRecord
  VISIT_TYPES = [
    DAY = "DAY",
    MONTH = "MONTH",
    YEAR = "YEAR"
  ]

  # Associations
  belongs_to :user, optional: true
  belongs_to :visited, polymorphic: true

  # Validations
  validates_inclusion_of :period, in: VISIT_TYPES
  validates_inclusion_of :visited_type, in: ["Comic", "Issue"]
  validates_presence_of :period_start, :period_end
  validates :user_id, uniqueness: {scope: [:visited_type, :visited_id, :period, :period_start, :period_end], message: "combination already exists"}
end
