# frozen_string_literal: true

require "rails_helper"

RSpec.describe ResourceTileControlComponent, type: :component do
  include Rails.application.routes.url_helpers

  let(:user) { FactoryBot.create(:user) }
  let(:issue) { FactoryBot.create(:issue, issue_number: 1, image: "google.com") }

  before do
    render_inline(described_class.new(issue:, user:, read_at: DateTime.new(2023, 7, 7, 10, 0)))
  end

  it "renders the actions" do
    expect(page).to have_css "i.fa-check"
    expect(page).to have_css "i.fa-star"
    expect(page).to have_css "i.fa-book-open"
    expect(page).to have_css "i.fa-heart"
  end

  it "renders a link to the issue" do
    expect(page).to have_css "a[href='#{comic_issue_path(issue, comic_id: issue.comic.id)}']"
  end

  it "renders the issue image" do
    expect(page).to have_css "img[src='google.com']"
  end

  it "renders the issue number and time read" do
    expect(page).to have_content "#1"
    expect(page).to have_content "7 Jul 10:00"
  end
end
