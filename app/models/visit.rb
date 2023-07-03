class Visit < ApplicationRecord
  # Associations
  belongs_to :user, optional: true
  belongs_to :visited, polymorphic: true
end
