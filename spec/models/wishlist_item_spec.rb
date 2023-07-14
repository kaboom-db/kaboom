require "rails_helper"

RSpec.describe WishlistItem, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:wishlistable) }
  end

  describe "validations" do
    subject { FactoryBot.create(:wishlist_item) }
    it { should validate_uniqueness_of(:user_id).scoped_to([:wishlistable_id, :wishlistable_type]) }
  end
end
