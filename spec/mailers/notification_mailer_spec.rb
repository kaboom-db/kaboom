require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  describe "#notify_new_issue" do
    let(:users) { [FactoryBot.create(:user, email: "test@example.com"), FactoryBot.create(:user, email: "test2@example.com")] }
    let(:comic) { FactoryBot.create(:comic, name: "Test Comic") }
    let(:notifiable) { FactoryBot.create(:issue, comic:, issue_number: 1) }

    it "sends an email to the users" do
      email = NotificationMailer.notify_new_issue(users:, notifiable:)
      assert_emails 1 do
        email.deliver_now
      end

      assert_equal ["hello@kaboom.rocks"], email.from
      assert_equal ["test@example.com", "test2@example.com"], email.bcc
      assert_equal "New issue available for Test Comic on Kaboom!", email.subject
      expect(email.body).to include(comic_issue_url(notifiable, comic_id: comic))
      expect(email.body).to include(notifiable.image)
      expect(email.body).to include(notifiable.name)
      expect(email.body).to include(comic.name)
    end
  end

  describe ".type_hash_map" do
    it "returns the type hash map" do
      expect(NotificationMailer.type_hash_map).to eq({
        Notification::NEW_ISSUE => :notify_new_issue
      })
    end
  end
end
