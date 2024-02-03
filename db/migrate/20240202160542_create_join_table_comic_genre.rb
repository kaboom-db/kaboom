class CreateJoinTableComicGenre < ActiveRecord::Migration[7.0]
  def change
    create_join_table :comics, :genres do |t|
      # t.index [:comic_id, :genre_id]
      # t.index [:genre_id, :comic_id]
    end
  end
end
