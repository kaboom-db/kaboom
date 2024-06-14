require "rails_helper"

RSpec.describe VisitBucket, type: :model do
  describe "associations" do
    it { should belong_to(:user).optional }
    it { should belong_to(:visited) }
  end

  describe "validations" do
    it { should validate_inclusion_of(:period).in_array(VisitBucket::VISIT_TYPES) }
    it { should validate_inclusion_of(:visited_type).in_array(["Comic", "Issue"]) }
    it { should validate_presence_of(:period_start) }
    it { should validate_presence_of(:period_end) }
  end

  describe "uniqueness" do
    subject { FactoryBot.create(:visit_bucket) }

    it { should validate_uniqueness_of(:user_id).scoped_to(:visited_type, :visited_id, :period, :period_start, :period_end).with_message("combination already exists") }
  end
end
