require "rails_helper"

RSpec.describe Rating, type: :model do
  describe "associations" do
    it { should belong_to :user }
    it { should belong_to :rateable }
  end

  describe "validations" do
    subject { FactoryBot.create(:rating) }
    it { should validate_uniqueness_of(:user_id).scoped_to([:rateable_id, :rateable_type]) }
    it { should validate_numericality_of(:score).is_greater_than_or_equal_to(1).is_less_than_or_equal_to(10) }
  end
end
