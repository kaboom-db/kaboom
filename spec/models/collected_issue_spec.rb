require "rails_helper"

RSpec.describe CollectedIssue, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:issue) }
    it { should have_one(:comic).through(:issue) }
  end

  describe "validations" do
    subject { FactoryBot.create(:collected_issue) }
    it { should validate_uniqueness_of(:issue_id).scoped_to(:user_id) }
  end

  describe "#social_class" do
    it "returns CollectedActivity" do
      expect(CollectedIssue.new.social_class).to eq Social::CollectedActivity
    end
  end
end
