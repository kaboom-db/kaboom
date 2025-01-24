# frozen_string_literal: true

require "rails_helper"

RSpec.describe TopReviewComponent, type: :component do
  include Rails.application.routes.url_helpers

  let(:user) { FactoryBot.build(:user, username: "test@example.com") }
  let(:score) { nil }

  before do
    if score
      FactoryBot.create(:rating, user:, score:, rateable: review.reviewable)
    end
    render_inline(described_class.new(review:))
  end

  context "when review is not present" do
    let(:review) { nil }

    it "renders no data" do
      expect(page).to have_content "NO DATA"
    end
  end

  context "when review is present" do
    let(:review) { FactoryBot.create(:review, title: "Amazing Comic!!", user:) }
    let(:score) { 9.0 }

    it "renders the review title" do
      expect(page).to have_content "Amazing Comic!!"
    end

    it "renders the user's username" do
      expect(page).to have_content "test@example.com"
    end

    it "renders the number of likes" do
      expect(page).to have_content "0 likes"
    end

    it "renders the score without a trailing .0" do
      expect(page).to have_css "b.left-0", text: "9"
    end

    it "renders a link to the review" do
      expect(page).to have_css "a[href='#{review_path(review)}']"
    end

    context "when the score is within a third of 100" do
      let(:score) { 2 }

      it "renders a red background" do
        expect(page.native.to_s).to include("from-[#f6504b] hover:bg-[#f6504b] md:ml-16")
      end
    end

    context "when the score is within two thirds of 100" do
      let(:score) { 5 }

      it "renders a yello background" do
        expect(page.native.to_s).to include("from-[#e0ca3c] hover:bg-[#e0ca3c] md:ml-8")
      end
    end

    context "when the score is within three thirds of 100" do
      let(:score) { 9 }

      it "renders a green background" do
        expect(page.native.to_s).to include("from-[#00df77] hover:bg-[#00df77]")
      end
    end

    context "when there is no score" do
      let(:score) { nil }

      it "renders 0" do
        expect(page).to have_css "b.left-0", text: "0"
      end

      it "does not render a coloured background" do
        expect(page.native.to_s).not_to include("from-[#f6504b] hover:bg-[#f6504b] md:ml-16")
        expect(page.native.to_s).not_to include("from-[#e0ca3c] hover:bg-[#e0ca3c] md:ml-8")
        expect(page.native.to_s).not_to include("from-[#00df77] hover:bg-[#00df77]")
      end
    end
  end
end
