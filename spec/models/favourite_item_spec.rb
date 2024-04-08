require "rails_helper"

RSpec.describe FavouriteItem, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:favouritable) }
  end

  describe "validations" do
    subject { FactoryBot.create(:favourite_item) }
    it { should validate_uniqueness_of(:user_id).scoped_to([:favouritable_id, :favouritable_type]) }
  end

  describe "#social_class" do
    it "returns FavouritedActivity" do
      expect(FavouriteItem.new.social_class).to eq Social::FavouritedActivity
    end
  end
end
