# frozen_string_literal: true

require "rails_helper"

module Social
  RSpec.describe FollowManager do
    let(:target) { FactoryBot.create(:user) }
    let(:follower) { FactoryBot.create(:user) }
    let(:follow_manager) { FollowManager.new(target:, follower:) }

    describe "#follow" do
      subject { follow_manager.follow }

      context "when follower and target are the same person" do
        let(:target) { follower }

        it "returns false and does not add a follow" do
          expect(subject).to eq false
          expect(Follow.count).to eq 0
        end
      end

      context "when follower is already following target" do
        before do
          FactoryBot.create(:follow, target:, follower:)
        end

        it "returns true but does not add any further follows" do
          expect(subject).to eq true
          expect(Follow.count).to eq 1
        end
      end

      context "when follower is not following target" do
        it "returns true and adds a follow" do
          expect(subject).to eq true
          expect(Follow.count).to eq 1
          follow = Follow.last
          expect(follow.target).to eq target
          expect(follow.follower).to eq follower
        end
      end
    end

    describe "#unfollow" do
      subject { follow_manager.unfollow }

      context "when follower and target are the same person" do
        let(:target) { follower }

        it "returns false" do
          expect(subject).to eq false
        end
      end

      context "when follower is not following target" do
        it "returns true" do
          expect(subject).to eq true
        end
      end

      context "when follower is following target" do
        before do
          FactoryBot.create(:follow, target:, follower:)
        end

        it "returns true and removes the follow" do
          expect(subject).to eq true
          expect(Follow.count).to eq 0
        end
      end
    end

    describe "#following?" do
      subject { follow_manager.following? }

      context "when the follower is following the target" do
        before do
          FactoryBot.create(:follow, target:, follower:)
        end

        it "returns true" do
          expect(subject).to eq true
        end
      end

      context "when the follower is not following the target" do
        it "returns false" do
          expect(subject).to eq false
        end
      end
    end
  end
end
