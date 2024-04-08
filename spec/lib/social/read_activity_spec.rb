# frozen_string_literal: true

require "rails_helper"

module Social
  RSpec.describe ReadActivity do
    include Rails.application.routes.url_helpers

    let(:user) { FactoryBot.create(:user, username: "BobMan") }
    let(:comic) { FactoryBot.create(:comic, name: "Amazing Comic") }
    let(:issue) { FactoryBot.create(:issue, comic:, issue_number: "1", name: "Amazing Issue", image: "/path/to/image.jpg") }
    let(:record) { ReadIssue.new(user:, issue:, read_at: DateTime.new(2024, 1, 1, 10)) }
    let(:activity) { ReadActivity.new(record:) }

    describe "#content" do
      subject { activity.content }

      it "returns the content of the activity" do
        expect(subject).to eq "BobMan read Issue #1 of Amazing Comic (Amazing Issue)"
      end
    end

    describe "#link" do
      subject { activity.link }

      it "returns the link to the issue" do
        expect(subject).to eq comic_issue_path(issue, comic_id: comic)
      end
    end

    describe "#timestamp" do
      subject { activity.timestamp }

      it "returns the date of collection at noon" do
        expect(subject).to eq DateTime.new(2024, 1, 1, 10)
      end
    end

    describe "#image" do
      subject { activity.image }

      it "returns the issue's image" do
        expect(subject).to eq "/path/to/image.jpg"
      end
    end

    describe "#type" do
      subject { activity.type }

      it "returns the class of the activity as a string" do
        expect(subject).to eq "Social::ReadActivity"
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
