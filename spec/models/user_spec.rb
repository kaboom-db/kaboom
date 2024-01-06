require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many(:read_issues).dependent(:delete_all) }
    it { should have_many(:comics).through(:read_issues) }
    it { should have_many(:issues_read).through(:read_issues).source(:issue) }
    it { should have_many(:visits).dependent(:delete_all) }
    it { should have_many(:wishlist_items).dependent(:delete_all) }
    it { should have_many(:wishlisted_comics).through(:wishlist_items).class_name("Comic") }
    it { should have_many(:wishlisted_issues).through(:wishlist_items).class_name("Issue") }
    it { should have_many(:favourite_items).dependent(:delete_all) }
    it { should have_many(:favourited_comics).through(:favourite_items).class_name("Comic") }
    it { should have_many(:favourited_issues).through(:favourite_items).class_name("Issue") }
    it { should have_many(:collected_issues).dependent(:delete_all) }
    it { should have_many(:collection).through(:collected_issues).source(:issue) }
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

  describe "#to_param" do
    let(:user) { FactoryBot.build(:user, username: "ObiWan") }

    it "returns the username" do
      expect(user.to_param).to eq "ObiWan"
    end
  end

  describe "#completed_comics" do
    let(:user) { FactoryBot.create(:user) }

    before do
      @comic1 = FactoryBot.create(:comic, count_of_issues: 2)
      issue1 = FactoryBot.create(:issue, comic: @comic1)
      issue2 = FactoryBot.create(:issue, comic: @comic1)

      @comic2 = FactoryBot.create(:comic, count_of_issues: 2)
      issue3 = FactoryBot.create(:issue, comic: @comic2)
      issue4 = FactoryBot.create(:issue, comic: @comic2)

      FactoryBot.create(:read_issue, user:, issue: issue1)
      FactoryBot.create(:read_issue, user:, issue: issue1) # Does not count this towards the progress of the comic

      FactoryBot.create(:read_issue, user:, issue: issue3)
      FactoryBot.create(:read_issue, user:, issue: issue4)
    end

    it "returns the users completed comics" do
      expect(user.completed_comics.to_a).to eq [@comic2]
    end
  end

  describe "#incompleted_comics" do
    let(:user) { FactoryBot.create(:user) }

    before do
      @comic1 = FactoryBot.create(:comic, count_of_issues: 2)
      issue1 = FactoryBot.create(:issue, comic: @comic1)
      issue2 = FactoryBot.create(:issue, comic: @comic1)

      @comic2 = FactoryBot.create(:comic, count_of_issues: 2)
      issue3 = FactoryBot.create(:issue, comic: @comic2)
      issue4 = FactoryBot.create(:issue, comic: @comic2)

      FactoryBot.create(:read_issue, user:, issue: issue1)
      FactoryBot.create(:read_issue, user:, issue: issue1) # Does not count this towards the progress of the comic

      FactoryBot.create(:read_issue, user:, issue: issue3)
      FactoryBot.create(:read_issue, user:, issue: issue4)
    end

    it "returns the users completed comics" do
      expect(user.incompleted_comics.to_a).to eq [@comic1]
    end
  end
end
