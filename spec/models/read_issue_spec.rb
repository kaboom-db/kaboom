require "rails_helper"

RSpec.describe ReadIssue, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:issue) }
    it { should have_one(:comic).through(:issue) }
  end

  describe "validations" do
    it { should validate_presence_of(:read_at) }
  end

  describe "#social_class" do
    it "returns ReadActivity" do
      expect(ReadIssue.new.social_class).to eq Social::ReadActivity
    end
  end
end
