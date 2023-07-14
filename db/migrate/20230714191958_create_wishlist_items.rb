class CreateWishlistItems < ActiveRecord::Migration[7.0]
  def change
    create_table :wishlist_items do |t|
      t.references :user, null: false, foreign_key: true
      t.string :wishlistable_type
      t.bigint :wishlistable_id

      t.timestamps
    end
  end
end
