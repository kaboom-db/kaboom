# frozen_string_literal: true

require "rails_helper"

module Social
  RSpec.describe Feed do
    describe "#generate" do
      before do
        @user = FactoryBot.create(:user, username: "Obi-Wan")
        @user2 = FactoryBot.create(:user, username: "Anakin")
        comic = FactoryBot.create(:comic, name: "My Comic")
        issue = FactoryBot.create(:issue, issue_number: "1", name: "Test Issue")
        @read_issue = FactoryBot.create(:read_issue, issue:, user: @user, read_at: DateTime.new(2024, 1, 1, 18, 9))
        @collected_issue = FactoryBot.create(:collected_issue, issue:, user: @user, collected_on: Date.new(2024, 1, 1))
        @wishlist_item = FactoryBot.create(:wishlist_item, wishlistable: comic, user: @user, created_at: DateTime.new(2024, 1, 1, 8))
        @favourite_item = FactoryBot.create(:favourite_item, favouritable: issue, user: @user, created_at: DateTime.new(2024, 1, 1, 22, 7))
        @follow1 = FactoryBot.create(:follow, target: @user2, follower: @user, created_at: DateTime.new(2024, 1, 1, 6))
        @follow2 = FactoryBot.create(:follow, target: @user, follower: @user2, created_at: DateTime.new(2024, 1, 1, 21, 10))
        @rating1 = FactoryBot.create(:rating, user: @user, score: 3, updated_at: DateTime.new(2024, 1, 1, 6))
        @rating2 = FactoryBot.create(:rating, user: @user2, score: 4, updated_at: DateTime.new(2024, 1, 1, 21, 10))
      end

      context "when page is too large" do
        it "returns an empty array" do
          feed = Feed.new(activities_by: @user, page: 100000)
          expect(feed.generate).to eq []
        end
      end

      context "when there are more results than per page" do
        before do
          stub_const("Social::Feed::PER_PAGE", 1)
        end

        it "only returns results for that page" do
          feed = Feed.new(activities_by: @user, page: 2)
          activities = feed.generate
          expect(activities.size).to eq 1
          activity = activities.first
          expect(activity.record).to eq @read_issue # Second most recent activity
        end
      end

      context "when there are less results than per page" do
        it "returns the activities created by `activities_by` in order of time descending" do
          feed = Feed.new(activities_by: @user, page: 1)
          activities = feed.generate
          expect(activities.size).to eq 6
          expect(activities.first.record).to eq @favourite_item
          expect(activities.second.record).to eq @read_issue
          expect(activities.third.record).to eq @collected_issue
          expect(activities.fourth.record).to eq @wishlist_item
          expect(activities[4].record).to eq @rating1
          expect(activities[5].record).to eq @follow1
        end
      end

      context "when activities by is multiple users" do
        it "returns the activities created by those users in order of time descending" do
          feed = Feed.new(activities_by: [@user, @user2], page: 1)
          activities = feed.generate
          expect(activities.size).to eq 8
          expect(activities.first.record).to eq @favourite_item
          expect(activities.second.record).to eq @rating2
          expect(activities.third.record).to eq @follow2
          expect(activities.fourth.record).to eq @read_issue
          expect(activities[4].record).to eq @collected_issue
          expect(activities[5].record).to eq @wishlist_item
          expect(activities[6].record).to eq @rating1
          expect(activities[7].record).to eq @follow1
        end
      end
    end
  end
end
