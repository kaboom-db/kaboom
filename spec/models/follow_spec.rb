require "rails_helper"

RSpec.describe Follow, type: :model do
  describe "associations" do
    it { should belong_to(:target).class_name("User") }
    it { should belong_to(:follower).class_name("User") }
  end

  describe "#notify_target!" do
    let(:target) { FactoryBot.create(:user, allow_email_notifications:) }
    let(:follower) { FactoryBot.create(:user) }

    context "when target has email notifications turned on" do
      let(:allow_email_notifications) { true }

      it "sends an email" do
        message_delivery = instance_double(ActionMailer::MessageDelivery)
        expect(UserMailer).to receive(:notify_follower)
          .and_return(message_delivery)
        expect(message_delivery).to receive(:deliver_later)
        Follow.create(target:, follower:)
      end
    end

    context "when target does not have email notifications turned on" do
      let(:allow_email_notifications) { false }

      it "does not send an email" do
        expect(UserMailer).not_to receive(:notify_follower)
        Follow.create(target:, follower:)
      end
    end
  end
end
