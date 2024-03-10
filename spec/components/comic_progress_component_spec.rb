# frozen_string_literal: true

require "rails_helper"

RSpec.describe ComicProgressComponent, type: :component do
  include Rails.application.routes.url_helpers

  context "when there is a next issue" do
    it "renders the component with next issue text" do
      comic = FactoryBot.create(:comic, name: "Test Comic", count_of_issues: 2)
      issue = FactoryBot.create(:issue, comic:, absolute_number: 1, issue_number: "1")
      issue2 = FactoryBot.create(:issue, comic:, absolute_number: 2, issue_number: "2", image: "/path/to/image.png")
      current_user = FactoryBot.create(:user)
      FactoryBot.create(:read_issue, issue:, user: current_user)
      render_inline(described_class.new(comic:, current_user:))
      expect(page).to have_css "img[src='/path/to/image.png']"
      expect(page).to have_css "a[href='#{comic_path(comic)}']"
      expect(page).to have_css "a[href='#{comic_issue_path(issue2, comic_id: comic)}']"
      expect(page).to have_content "Test Comic"
      expect(page).to have_content "Next: Issue #2"
      expect(page).to have_content "50%"
      expect(page).to have_css "div[style='width: 50%;']"
    end
  end

  context "when there isn't next issue" do
    it "renders the component without next issue text" do
      comic = FactoryBot.create(:comic, name: "Test Comic", count_of_issues: 2, image: "/path/to/image.png")
      issue = FactoryBot.create(:issue, comic:, absolute_number: 1, issue_number: "1")
      current_user = FactoryBot.create(:user)
      FactoryBot.create(:read_issue, issue:, user: current_user)
      render_inline(described_class.new(comic:, current_user:))
      expect(page).to have_css "img[src='/path/to/image.png']"
      expect(page).to have_css "a[href='#{comic_path(comic)}']"
      expect(page).to have_content "Test Comic"
      expect(page).not_to have_content "Next: Issue"
      expect(page).to have_content "50%"
      expect(page).to have_css "div[style='width: 50%;']"
    end
  end
end
