require "rails_helper"

RSpec.describe Review, type: :model do
  describe "associations" do
    it { should belong_to :user }
    it { should belong_to :reviewable }
  end

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:content) }
    it { should validate_inclusion_of(:reviewable_type).in_array(Review::REVIEWABLE_TYPES) }
  end

  describe "uniqueness" do
    subject { FactoryBot.create(:review) }
    it { should validate_uniqueness_of(:user_id).scoped_to([:reviewable_id, :reviewable_type]) }
  end

  describe "#score" do
    let(:resource) { FactoryBot.create(:comic) }
    let(:user) { FactoryBot.create(:user) }

    context "when the user has a rating for the resource" do
      before do
        FactoryBot.create(:rating, score: 4, user:, rateable: resource)
      end

      it "returns the ratings score" do
        review = Review.new(user:, reviewable: resource)
        expect(review.score).to eq 4
      end
    end

    context "when the user does not have a rating for the resource" do
      it "returns 0" do
        review = Review.new(user:, reviewable: resource)
        expect(review.score).to eq 0
      end
    end
  end

  describe "#tier" do
    let(:user) { FactoryBot.create(:user) }
    let(:review) { FactoryBot.create(:review, user:, reviewable: resource) }
    let(:resource) { FactoryBot.create(:comic) }

    subject { review.tier }

    before do
      if score > 0
        FactoryBot.create(:rating, rateable: resource, score:, user:)
      end
    end

    context "when score is 0" do
      let(:score) { 0 }

      it { should be_nil }
    end

    context "when score is within 1/3" do
      let(:score) { 1 }

      it { should eq 0 }
    end

    context "when score is within 2/3" do
      let(:score) { 5 }

      it { should eq 1 }
    end

    context "when score is within 3/3" do
      let(:score) { 8 }

      it { should eq 2 }
    end

    context "when the score is 10" do
      let(:score) { 10 }

      it { should eq 2 }
    end
  end
end
