class NotificationCreator
  def initialize(users:, notifiable:, notification_type:)
    @users = users
    @notifiable = notifiable
    @notifiable_type = notifiable&.class&.to_s
    @notification_type = notification_type

    raise "Invalid notification type" unless Notification::TYPES.include?(notification_type)
    raise "Invalid notifiable" if @notifiable && Notification::NOTIFIABLES.exclude?(@notifiable_type)
  end

  def self.create(users:, notifiable:, notification_type:)
    new(users:, notifiable:, notification_type:).create
  end

  def create
    notification_data = @users.map do |user|
      {
        user_id: user.id,
        notifiable_id: @notifiable&.id,
        notifiable_type: @notifiable_type,
        notification_type: @notification_type
      }
    end
    Notification.insert_all(notification_data)
  end
end
