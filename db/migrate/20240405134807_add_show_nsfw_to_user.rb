class AddShowNsfwToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :show_nsfw, :boolean, default: false, null: false
  end
end
