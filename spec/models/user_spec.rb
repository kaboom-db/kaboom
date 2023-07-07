require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many(:read_issues).dependent(:delete_all) }
    it { should have_many(:issues_read).through(:read_issues).source(:issue) }
    it { should have_many(:visits).dependent(:delete_all) }
  end

  describe "validations" do
    subject { FactoryBot.create(:user) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
  end

  describe "#avatar" do
    let(:user) { FactoryBot.create(:user, :confirmed, email: "hello@there.obi") }

    it "gets the avatar for the user from Gravatar" do
      expect(user.avatar).to eq "https://www.gravatar.com/avatar/898e4fc667e28813fe2ba58a7cec6286?d=retro"
    end
  end
end
