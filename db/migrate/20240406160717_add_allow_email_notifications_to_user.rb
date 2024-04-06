class AddAllowEmailNotificationsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :allow_email_notifications, :boolean, null: false, default: true
  end
end
