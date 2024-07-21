require "rails_helper"

RSpec.describe HiddenComic, type: :model do
  describe "associations" do
    it { should belong_to(:comic) }
    it { should belong_to(:user) }
  end

  describe "validations" do
    subject { FactoryBot.create(:hidden_comic) }

    it { should validate_uniqueness_of(:user_id).scoped_to(:comic_id) }
  end
end
