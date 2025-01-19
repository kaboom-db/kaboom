# frozen_string_literal: true

require "rails_helper"

RSpec.describe StarRatingComponent, type: :component do
  context "when current_user is not present" do
    it "does not render" do
      render_inline(described_class.new(current_user: nil, rate_url: ""))
      expect(page).to have_css "div[data-controller='star-rating']", count: 0
    end
  end

  context "when current_user is present" do
    it "renders the component" do
      current_user = FactoryBot.create(:user)
      render_inline(described_class.new(current_user:, rate_url: "/url/for/rating", rating: 25))
      expect(page).to have_css "div[data-controller='star-rating']"
      expect(page).to have_css "div[data-star-rating-current-score-value='25']"
      expect(page).to have_css "div[data-star-rating-url-value='/url/for/rating']"
    end
  end
end
