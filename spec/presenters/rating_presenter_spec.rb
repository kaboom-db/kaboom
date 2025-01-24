# frozen_string_literal: true

require "rails_helper"

RSpec.describe RatingPresenter, type: :presenter do
  let(:presenter) { RatingPresenter.new(resource:, current_user:) }
  let(:resource) { FactoryBot.create(:comic) }
  let(:current_user) { nil }

  describe "#user_rating" do
    subject { presenter.user_rating }

    context "when there is no current user" do
      let(:current_user) { nil }

      it { should eq 0 }
    end

    context "when the current user does not have a rating for the resource" do
      let(:current_user) { FactoryBot.create(:user) }

      before do
        FactoryBot.create(:rating, user: current_user) # Not for the right resource
      end

      it { should eq 0 }
    end

    context "when the current user has a rating for the resource" do
      let(:current_user) { FactoryBot.create(:user) }

      before do
        FactoryBot.create(:rating, user: current_user, rateable: resource, score: 8)
      end

      it { should eq 8 }
    end
  end

  describe "#average_rating" do
    subject { presenter.average_rating }

    context "when the resource does not have any ratings" do
      it { should eq 0 }
    end

    context "when the resource has ratings" do
      before do
        FactoryBot.create(:rating, score: 4, rateable: resource)
        FactoryBot.create(:rating, score: 5, rateable: resource)
        FactoryBot.create(:rating, score: 4, rateable: resource)
      end

      it { should eq 4.33 }
    end
  end

  describe "#top_reviews" do
    subject { presenter.top_reviews }

    context "when the resource has no ratings" do
      it "returns an array with 3 nils" do
        expect(subject).to eq [nil, nil, nil]
      end
    end

    context "when the rating has less than 3 ratings" do
      before do
        @review1 = FactoryBot.create(:review, reviewable: resource, created_at: 3.seconds.ago)
        @review2 = FactoryBot.create(:review, reviewable: resource, created_at: 2.seconds.ago)
      end

      it "returns the reviews ordered by desc created_at with nil for empty review" do
        expect(subject).to eq [@review2, @review1, nil]
      end
    end

    context "when the rating has 3 or more ratings" do
      before do
        @review1 = FactoryBot.create(:review, reviewable: resource, created_at: 3.seconds.ago)
        @review2 = FactoryBot.create(:review, reviewable: resource, created_at: 1.seconds.ago)
        @review3 = FactoryBot.create(:review, reviewable: resource, created_at: 2.seconds.ago)
      end

      it "returns the reviews ordered by desc created_at" do
        expect(subject).to eq [@review2, @review3, @review1]
      end
    end
  end
end
