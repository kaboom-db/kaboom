# frozen_string_literal: true

require "rails_helper"

RSpec.describe RatingSectionComponent, type: :component do
  let(:issue) { FactoryBot.create(:issue) }
  let(:rating_presenter) { RatingPresenter.new(rateable: issue) }

  it "renders a link to more reviews" do
    render_inline(described_class.new(rating_presenter:, reviews_path: "/"))
    expect(page).to have_css "a[href='/']", text: "More reviews"
  end

  it "renders the top reviews" do
    FactoryBot.create(:review, title: "Review One", reviewable: issue)
    FactoryBot.create(:review, title: "Review Two", reviewable: issue)
    render_inline(described_class.new(rating_presenter:, reviews_path: "/"))
    expect(page).to have_content "Review One"
    expect(page).to have_content "Review Two"
    expect(page).to have_content "NO DATA"
  end
end
