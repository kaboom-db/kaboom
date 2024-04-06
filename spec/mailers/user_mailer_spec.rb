require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "#notify_follower" do
    let(:target) { FactoryBot.create(:user, username: "crxssed", email: "test@example.com") }
    let(:follower) { FactoryBot.create(:user, username: "bobbob", email: "bob@example.com") }
    let(:follow) { FactoryBot.create(:follow, target:, follower:) }

    it "sends an email to the target" do
      email = UserMailer.notify_follower(follow:)
      assert_emails 1 do
        email.deliver_now
      end

      assert_equal ["hello@kaboom.rocks"], email.from
      assert_equal ["test@example.com"], email.to
      assert_equal "bobbob started following you on Kaboom!", email.subject
      expect(email.body).to include(user_url(follower))
      expect(email.body).to include(edit_user_url(target))
      expect(email.body).to include("We&#39;re here to notify you that bobbob has started following you on Kaboom! You can view their Kaboom profile with the link below.")
      expect(email.body).to include("If you no longer wish to receive these notifications from us, you can disable them in your account settings.")
    end
  end
end
