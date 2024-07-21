class AddUniqueIndexToHiddenComic < ActiveRecord::Migration[7.1]
  def change
    add_index :hidden_comics, [:user_id, :comic_id], unique: true, name: "index_hidden_comics_on_unique_combination"
  end
end
