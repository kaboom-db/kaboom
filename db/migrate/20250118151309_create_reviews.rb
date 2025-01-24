class CreateReviews < ActiveRecord::Migration[8.0]
  def change
    create_table :reviews do |t|
      t.string :title
      t.text :content
      t.references :user, null: false, foreign_key: true
      t.string :reviewable_type
      t.bigint :reviewable_id

      t.timestamps
    end

    add_index :reviews, [:user_id, :reviewable_type, :reviewable_id], unique: true
  end
end
