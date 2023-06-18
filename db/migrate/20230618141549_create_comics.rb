class CreateComics < ActiveRecord::Migration[7.0]
  def change
    create_table :comics do |t|
      t.text :aliases
      t.string :api_detail_url
      t.integer :count_of_issues
      t.datetime :date_last_updated
      t.text :deck
      t.text :description
      t.integer :cv_id, unique: true, null: false
      t.string :image
      t.string :name, null: false
      t.string :publisher
      t.string :site_detail_url
      t.integer :start_year

      t.timestamps
    end
  end
end
