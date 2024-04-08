# frozen_string_literal: true

require "rails_helper"

module Social
  RSpec.describe FavouritedActivity do
    include Rails.application.routes.url_helpers

    let(:user) { FactoryBot.create(:user, username: "BobMan") }
    let(:favouritable) { FactoryBot.create(:comic, name: "Amazing Comic", image: "amazing.png") }
    let(:record) { FavouriteItem.new(user:, favouritable:, created_at: DateTime.new(2024, 1, 1, 10, 15)) }
    let(:activity) { FavouritedActivity.new(record:) }

    describe "#content" do
      subject { activity.content }

      it "returns the content of the activity" do
        expect(subject).to eq "BobMan favourited Amazing Comic"
      end
    end

    describe "#link" do
      subject { activity.link }

      context "when favouritable is a comic" do
        it "returns the link to the comic" do
          expect(subject).to eq comic_path(favouritable)
        end
      end

      context "when favouritable is an issue" do
        let(:comic) { FactoryBot.create(:comic) }
        let(:favouritable) { FactoryBot.create(:issue, comic:) }

        it "returns the link to the issue" do
          expect(subject).to eq comic_issue_path(favouritable, comic_id: comic)
        end
      end
    end

    describe "#timestamp" do
      subject { activity.timestamp }

      it "returns the time at which it was favourited" do
        expect(subject).to eq DateTime.new(2024, 1, 1, 10, 15)
      end
    end

    describe "#image" do
      subject { activity.image }

      it "returns the image" do
        expect(subject).to eq "amazing.png"
      end
    end

    describe "#type" do
      subject { activity.type }

      it "returns the class of the activity as a string" do
        expect(subject).to eq "Social::FavouritedActivity"
      end
    end

    describe "#user" do
      subject { activity.user }

      it "returns the record's user" do
        expect(subject).to eq user
      end
    end
  end
end
