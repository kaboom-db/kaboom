class AddFaIconToGenre < ActiveRecord::Migration[7.0]
  def change
    add_column :genres, :fa_icon, :string, null: false, default: "fa-masks-theater"
  end
end
