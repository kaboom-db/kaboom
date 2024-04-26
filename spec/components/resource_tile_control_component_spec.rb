# frozen_string_literal: true

require "rails_helper"

RSpec.describe ResourceTileControlComponent, type: :component do
  include Rails.application.routes.url_helpers

  let(:user) { FactoryBot.create(:user) }
  let(:issue) { FactoryBot.create(:issue, name: "Issue 1", issue_number: 1, image: "google.com") }

  context "when user exists" do
    before do
      FactoryBot.create(:read_issue, issue:, user:, read_at: DateTime.new(2023, 7, 7, 10, 0))
      render_inline(described_class.new(issue:, user:))
    end

    it "renders the actions" do
      expect(page).to have_css "i.fa-check"
      expect(page).to have_css "i.fa-cake-candles"
      expect(page).to have_css "i.fa-book-open"
      expect(page).to have_css "i.fa-heart"
    end

    it "renders a link to the issue and the name" do
      expect(page).to have_css "a[href='#{comic_issue_path(issue, comic_id: issue.comic.id)}']"
      expect(page).to have_css "b", text: "Issue 1"
    end

    it "renders the issue image" do
      expect(page).to have_css "img[src='google.com']"
    end

    it "renders the issue number and time read" do
      expect(page).to have_content "#1"
      expect(page).to have_content "7 Jul 10:00"
      expect(page).to have_css "div[data-controller='local-time']"
    end
  end

  context "when user is nil" do
    let(:user) { nil }

    before do
      render_inline(described_class.new(issue:, user:))
    end

    it "does not render the read_at" do
      expect(page).not_to have_css "div[data-controller='local-time']"
    end
  end
end
