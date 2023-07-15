class CreateFavouriteItems < ActiveRecord::Migration[7.0]
  def change
    create_table :favourite_items do |t|
      t.references :user, null: false, foreign_key: true
      t.string :favouritable_type
      t.bigint :favouritable_id

      t.timestamps
    end
  end
end
