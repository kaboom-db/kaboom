# frozen_string_literal: true

require "rails_helper"

RSpec.describe Actions::WishlistActionComponent, type: :component do
  let(:user) { FactoryBot.create(:user) }
  let(:resource) { FactoryBot.create(:issue) }

  before do
    render_inline(described_class.new(resource:, user:))
  end

  it "renders the button" do
    expect(page).to have_css "button.group"
  end

  it "renders the icon" do
    expect(page).to have_css "i.fa-cake-candles"
  end

  context "when resource is an Issue" do
    it "does not render any borders on the sides" do
      expect(page).to have_css "button.border-x-none"
    end
  end

  context "when resouce is not an issue" do
    let(:resource) { FactoryBot.create(:comic) }

    it "renders a border on the left but not the right" do
      expect(page).to have_css "button.border-l-2"
      expect(page).to have_css "button.border-r-none"
    end
  end
end
