class FavouriteItem < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :favouritable, polymorphic: true

  # Validations
  validates :user_id, uniqueness: {scope: [:favouritable_id, :favouritable_type]}
end
