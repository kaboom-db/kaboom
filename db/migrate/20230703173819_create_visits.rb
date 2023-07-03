class CreateVisits < ActiveRecord::Migration[7.0]
  def change
    create_table :visits do |t|
      t.references :user, null: true, foreign_key: true
      t.string :visited_type, null: false
      t.bigint :visited_id, null: false

      t.timestamps
    end
  end
end
