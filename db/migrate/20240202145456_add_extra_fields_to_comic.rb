class AddExtraFieldsToComic < ActiveRecord::Migration[7.0]
  def change
    add_column :comics, :nsfw, :boolean, default: false
    add_column :comics, :comic_type, :string
  end
end
