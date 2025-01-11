class CreateRatings < ActiveRecord::Migration[8.0]
  def change
    create_table :ratings do |t|
      t.references :user, null: false, foreign_key: true
      t.string :rateable_type
      t.bigint :rateable_id
      t.decimal :score

      t.timestamps
    end

    add_index :ratings, [:user_id, :rateable_type, :rateable_id], unique: true
  end
end
