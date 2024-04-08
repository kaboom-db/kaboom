# frozen_string_literal: true

require "rails_helper"

module Social
  RSpec.describe Activity do
    let(:user) { User.new }
    let(:record) { ReadIssue.new(user:) }
    let(:activity) { Activity.new(record:) }

    describe "#content" do
      subject { activity.content }

      it "returns an empty string" do
        expect(subject).to eq ""
      end
    end

    describe "#link" do
      subject { activity.link }

      it "returns nil" do
        expect(subject).to be_nil
      end
    end

    describe "#timestamp" do
      subject { activity.timestamp }

      it "returns nil" do
        expect(subject).to be_nil
      end
    end

    describe "#image" do
      subject { activity.image }

      it "returns nil" do
        expect(subject).to be_nil
      end
    end

    describe "#type" do
      subject { activity.type }

      it "returns the class of the activity as a string" do
        expect(subject).to eq "Social::Activity"
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
