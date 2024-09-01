class NotificationMailer < ApplicationMailer
  def notify_new_issue(users:, notifiable:)
    @notifiable = notifiable
    @header = "A new issue is available!"
    mail(bcc: users.map(&:email), subject: "New issue available for #{notifiable.comic} on Kaboom!")
  end

  def self.type_hash_map
    {
      Notification::NEW_ISSUE => :notify_new_issue
    }
  end
end
