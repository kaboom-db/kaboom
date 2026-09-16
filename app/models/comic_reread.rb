class ComicReread < ApplicationRecord
  # Assocations
  belongs_to :user
  belongs_to :comic

  # Validations
  validates_presence_of :reread_started_at
end
