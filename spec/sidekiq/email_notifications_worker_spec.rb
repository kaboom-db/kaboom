require "rails_helper"

RSpec.describe EmailNotificationsWorker do
  include ActiveSupport::Testing::TimeHelpers

  before do
    travel_to DateTime.new(2024, 1, 1, 10)

    # Users
    @user1 = FactoryBot.create(:user, email: "test1@example.com", allow_email_notifications: true)
    @user2 = FactoryBot.create(:user, email: "test2@example.com", allow_email_notifications: true)
    # A user who does not allow email notifications
    user3 = FactoryBot.create(:user, email: "test3@example.com", allow_email_notifications: false)

    comic = FactoryBot.create(:comic)

    # Issue 1
    issue1 = FactoryBot.create(:issue, comic:)
    # Make all the users readers of this comic
    FactoryBot.create(:read_issue, issue: issue1, user: @user1)
    FactoryBot.create(:read_issue, issue: issue1, user: @user2)
    FactoryBot.create(:read_issue, issue: issue1, user: user3)

    # From this point, we are creating notifications indirectly through the after_create callback on Issue
    # Issue 2, all the email notifications for this issue have already been sent
    @issue2 = FactoryBot.create(:issue, comic:)
    Notification.all.update(email_sent_at: Time.current - 10.days)

    # Issue 3
    @issue3 = FactoryBot.create(:issue, comic:)

    # Issue 4
    @issue4 = FactoryBot.create(:issue, comic:)
  end

  it "groups and sends emails for all the pending notifications" do
    message_delivery1 = instance_double(ActionMailer::MessageDelivery)
    expect(NotificationMailer).to receive(:send).with(:notify_new_issue, users: [@user1, @user2], notifiable: @issue3).and_return(message_delivery1)
    expect(message_delivery1).to receive(:deliver_later)

    message_delivery2 = instance_double(ActionMailer::MessageDelivery)
    expect(NotificationMailer).to receive(:send).with(:notify_new_issue, users: [@user1, @user2], notifiable: @issue4).and_return(message_delivery2)
    expect(message_delivery2).to receive(:deliver_later)

    EmailNotificationsWorker.new.perform
  end

  it "sets email sent at for all the notifications" do
    EmailNotificationsWorker.new.perform

    expect(Notification.where(email_sent_at: Time.current).count).to eq 6 # Only the 6 notifications were updated
  end
end
