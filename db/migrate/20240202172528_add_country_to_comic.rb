class AddCountryToComic < ActiveRecord::Migration[7.0]
  def change
    add_reference :comics, :country, null: true, foreign_key: true
  end
end
