# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview
  def notify_new_issue
    NotificationMailer.notify_new_issue(users: [User.first], notifiable: Issue.last)
  end
end
