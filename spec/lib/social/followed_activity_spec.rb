# frozen_string_literal: true

require "rails_helper"

module Social
  RSpec.describe FollowedActivity do
    include Rails.application.routes.url_helpers

    let(:target) { FactoryBot.create(:user, username: "BobMan") }
    let(:follower) { FactoryBot.create(:user, username: "JohnDoe") }
    let(:record) { Follow.new(target:, follower:, created_at: DateTime.new(2024, 1, 1, 14, 5)) }
    let(:activity) { FollowedActivity.new(record:) }

    describe "#content" do
      subject { activity.content }

      it "returns the content of the activity" do
        expect(subject).to eq "JohnDoe started following BobMan"
      end
    end

    describe "#link" do
      subject { activity.link }

      it "returns the link to the target user" do
        expect(subject).to eq user_path(target)
      end
    end

    describe "#timestamp" do
      subject { activity.timestamp }

      it "returns the time they were followed" do
        expect(subject).to eq DateTime.new(2024, 1, 1, 14, 5)
      end
    end

    describe "#image" do
      subject { activity.image }

      it "returns the target's avatar" do
        allow_any_instance_of(Gravatar::Image).to receive(:get).and_return("avatar.png")
        expect(subject).to eq "avatar.png"
      end
    end

    describe "#type" do
      subject { activity.type }

      it "returns the class of the activity as a string" do
        expect(subject).to eq "Social::FollowedActivity"
      end
    end

    describe "#user" do
      subject { activity.user }

      it "returns the record's user" do
        expect(subject).to eq follower
      end
    end
  end
end
