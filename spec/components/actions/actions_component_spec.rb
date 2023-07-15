# frozen_string_literal: true

require "rails_helper"

RSpec.describe Actions::ActionsComponent, type: :component do
  context "when there is no user specified" do
    it "does not render the component" do
      render_inline(described_class.new(resource: Issue.new, user: nil))
      expect(page).not_to have_css "div.grid"
    end
  end

  context "when there is a user specified" do
    let(:user) { FactoryBot.create(:user) }
    let(:resource) { FactoryBot.create(:issue) }

    before do
      render_inline(described_class.new(resource:, user:))
    end

    it "renders the actions" do
      expect(page).to have_css "i.fa-check"
      expect(page).to have_css "i.fa-star"
      expect(page).to have_css "i.fa-book-open"
      expect(page).to have_css "i.fa-heart"
    end
  end
end
