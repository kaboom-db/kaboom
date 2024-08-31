require "rails_helper"

RSpec.describe NotificationCreator do
  describe "#create" do
    let(:creator) { NotificationCreator.new(users:, notifiable:, notification_type:) }
    let(:users) { [] }
    let(:notifiable) { FactoryBot.create(:issue) }
    let(:notification_type) { Notification::CREATED }

    subject { creator.create }

    context "when the notification type is invalid" do
      let(:notification_type) { "INVALID" }

      it "raises an error" do
        expect { subject }.to raise_error("Invalid notification type")
      end
    end

    context "when the notifiable is invalid" do
      let(:notifiable) { FactoryBot.create(:comic) }

      it "raises an error" do
        expect { subject }.to raise_error("Invalid notifiable")
      end
    end

    context "when there are users" do
      let(:user1) { FactoryBot.create(:user) }
      let(:user2) { FactoryBot.create(:user) }
      let(:users) { [user1, user2] }

      it "creates notifications for the users" do
        subject
        expect(Notification.count).to eq 2
        notification1 = Notification.where(user: user1).first
        expect(notification1.notifiable).to eq notifiable
        expect(notification1.notification_type).to eq Notification::CREATED

        notification2 = Notification.where(user: user2).first
        expect(notification2.notifiable).to eq notifiable
        expect(notification2.notification_type).to eq Notification::CREATED
      end

      context "when notifiable is nil" do
        let(:notifiable) { nil }

        it "creates the notifications with a nil notifiable" do
          subject
          expect(Notification.count).to eq 2
          notification1 = Notification.where(user: user1).first
          expect(notification1.notifiable).to eq nil
          expect(notification1.notification_type).to eq Notification::CREATED

          notification2 = Notification.where(user: user2).first
          expect(notification2.notifiable).to eq nil
          expect(notification2.notification_type).to eq Notification::CREATED
        end
      end
    end

    context "when there are no users" do
      let(:users) { [] }

      it "does not create any notifications" do
        subject
        expect(Notification.count).to eq 0
      end
    end
  end
end
