class CreateComics < ActiveRecord::Migration[7.0]
  def change
    create_table :comics do |t|
      t.string :aliases
      t.string :api_detail_url
      t.integer :issue_count
      t.string :summary
      t.string :description
      t.integer :cv_id
      t.string :cover_image
      t.string :name
      t.integer :start_year

      t.timestamps
    end
  end
end
