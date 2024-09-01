class EmailNotificationsWorker
  include Sidekiq::Worker

  def perform
    grouped_notifications = Notification.where(email_sent_at: nil).group_by { [_1.notifiable, _1.notification_type] }
    grouped_notifications.each_pair do |keys, notifications|
      notifiable = keys.first
      notification_type = keys.last
      users = notifications.map(&:user).select { _1.allow_email_notifications == true }

      method = NotificationMailer.type_hash_map[notification_type]
      NotificationMailer.send(method, users:, notifiable:).deliver_later
      Notification.where(id: notifications.pluck(:id)).update(email_sent_at: Time.current)
    end
  end
end
