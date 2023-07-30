# frozen_string_literal: true

require "rails_helper"

RSpec.describe NavButtonComponent, type: :component do
  it "renders the button" do
    render_inline(described_class.new(href: "/path", icon: "test", text: "Hey There!"))
    expect(page).to have_link href: "/path"
    expect(page).to have_content "Hey There!"
    expect(page).to have_css ".fa-test"
  end

  context "when button is active" do
    it "renders the button in active state" do
      render_inline(described_class.new(href: "/path", icon: "test", text: "Hey There!", active: true))
      expect(page).to have_css ".bg-secondary"
    end
  end

  context "when button is in mobile mode" do
    it "does not render the text" do
      render_inline(described_class.new(href: "/path", icon: "test", text: "Hey There!", mobile: true))
      expect(page).not_to have_content "Hey There!"
    end
  end
end
