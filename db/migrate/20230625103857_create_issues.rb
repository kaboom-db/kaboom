class CreateIssues < ActiveRecord::Migration[7.0]
  def change
    create_table :issues do |t|
      t.text :aliases
      t.string :api_detail_url
      t.date :cover_date
      t.datetime :date_last_updated
      t.text :deck
      t.text :description
      t.integer :cv_id, unique: true, null: false
      t.string :image
      t.float :issue_number
      t.string :name
      t.string :site_detail_url
      t.date :store_date
      t.references :comic, null: false, foreign_key: true

      t.timestamps
    end
  end
end
