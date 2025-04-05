class AddPositionToWishlistItem < ActiveRecord::Migration[8.0]
  def change
    add_column :wishlist_items, :position, :integer
  end
end
