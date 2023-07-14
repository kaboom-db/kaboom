class WishlistItem < ApplicationRecord
  belongs_to :user
  belongs_to :wishlistable, polymorphic: true
end
