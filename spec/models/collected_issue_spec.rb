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
    it { should validate_numericality_of(:price_paid).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:price_paid).is_less_than_or_equal_to(100_000) }
  end

  describe "#social_class" do
    it "returns CollectedActivity" do
      expect(CollectedIssue.new.social_class).to eq Social::CollectedActivity
    end
  end
end
