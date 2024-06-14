class CreateVisitBuckets < ActiveRecord::Migration[7.1]
  def change
    create_table :visit_buckets do |t|
      t.string :period, null: false
      t.integer :period_start, null: false
      t.integer :period_end, null: false
      t.references :user, null: true, foreign_key: true
      t.string :visited_type, null: false
      t.bigint :visited_id, null: false
      t.integer :count

      t.timestamps
    end
  end
end
