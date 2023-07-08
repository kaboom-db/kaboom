# frozen_string_literal: true

require "rails_helper"

RSpec.describe Actions::ReadActionComponent, type: :component do
  let(:user) { FactoryBot.create(:user) }
  let(:issue) { FactoryBot.create(:issue) }

  before do
    FactoryBot.create(:read_issue, issue:, user:) if read

    render_inline(described_class.new(resource: issue, user:))
  end

  context "when user has not read the issue" do
    let(:read) { false }

    it "renders an unread button" do
      expect(page).to have_css "button[data-read='false']"
      expect(page).not_to have_css "button[data-read='true']"
    end

    it "renders the icon" do
      expect(page).to have_css "i.fa-check"
    end
  end

  context "when user has read the issue" do
    let(:read) { true }

    it "renders an unread button" do
      expect(page).to have_css "button[data-read='true']"
      expect(page).not_to have_css "button[data-read='false']"
    end

    it "renders the icon" do
      expect(page).to have_css "i.fa-check"
    end
  end
end
