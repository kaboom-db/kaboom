class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :read_at
      t.datetime :email_sent_at
      t.string :notifiable_type
      t.bigint :notifiable_id
      t.string :notification_type, null: false

      t.timestamps
    end
  end
end
