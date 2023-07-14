class WishlistItem < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :wishlistable, polymorphic: true

  # Validations
  validates :user_id, uniqueness: {scope: [:wishlistable_id, :wishlistable_type]}
end
