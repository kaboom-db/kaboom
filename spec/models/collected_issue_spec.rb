require "rails_helper"

RSpec.describe CollectedIssue, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:issue) }
  end

  describe "validations" do
    subject { FactoryBot.create(:collected_issue) }
    it { should validate_uniqueness_of(:issue_id).scoped_to(:user_id) }
  end
end
