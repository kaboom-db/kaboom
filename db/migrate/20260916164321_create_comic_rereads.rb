class CreateComicRereads < ActiveRecord::Migration[8.1]
  def change
    create_table :comic_rereads do |t|
      t.references :user, null: false, foreign_key: true
      t.references :comic, null: false, foreign_key: true
      t.datetime :reread_started_at, null: false

      t.timestamps
    end
  end
end
