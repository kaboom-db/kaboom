# frozen_string_literal: true

require "rails_helper"

RSpec.describe Actions::CollectActionComponent, type: :component do
  let(:user) { FactoryBot.create(:user) }
  let(:resource) { FactoryBot.create(:issue) }

  before do
    render_inline(described_class.new(resource:, user:))
  end

  it "renders the button" do
    expect(page).to have_css "button.group"
  end

  it "renders the icon" do
    expect(page).to have_css "i.fa-book-open"
  end

  it "renders the dialog with the inputs" do
    expect(page).to have_css "dialog[data-collect-target='dialog']"
    expect(page).to have_css "input[type='date'][data-collect-target='collectedOnInput']"
    expect(page).to have_css "input[type='number'][data-collect-target='pricePaidInput']"
  end
end
