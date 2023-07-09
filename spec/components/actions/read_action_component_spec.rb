# frozen_string_literal: true

require "rails_helper"

RSpec.describe Actions::ReadActionComponent, type: :component do
  let(:user) { FactoryBot.create(:user) }
  let(:resource) { FactoryBot.create(:issue) }

  before do
    render_inline(described_class.new(resource:, user:))
  end

  it "renders the button" do
    expect(page).to have_css "button.group"
  end

  it "renders the icon" do
    expect(page).to have_css "i.fa-check"
  end
end
