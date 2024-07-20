class CreateHiddenComics < ActiveRecord::Migration[7.1]
  def change
    create_table :hidden_comics do |t|
      t.references :comic, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
