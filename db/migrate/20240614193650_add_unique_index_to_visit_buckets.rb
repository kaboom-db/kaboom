class AddUniqueIndexToVisitBuckets < ActiveRecord::Migration[7.1]
  def change
    add_index :visit_buckets, [:user_id, :visited_type, :visited_id, :period, :period_start, :period_end], unique: true, name: "index_visit_buckets_on_unique_combination"
  end
end
