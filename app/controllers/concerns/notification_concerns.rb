# frozen_string_literal: true

module NotificationConcerns
  extend ActiveSupport::Concern

  def mark_notifications(user:, notifiable:)
    Notification.where(user:, notifiable:, read_at: nil).update(read_at: Time.current)
  end
end
