# frozen_string_literal: true

require "rails_helper"

RSpec.describe NavButtonComponent, type: :component do
  it "renders the button" do
    render_inline(described_class.new(href: "/path", icon: "test", text: "Hey There!"))
    expect(page).to have_link href: "/path"
    expect(page).to have_css ".fa-test"
    expect(page).to have_css "a[data-turbo-method='get']"
    expect(page).not_to have_css ".border-2"
  end

  context "when button is active" do
    it "renders the button in active state" do
      render_inline(described_class.new(href: "/path", icon: "test", text: "Hey There!", active: true))
      expect(page).to have_css ".border-2"
    end
  end

  context "when a method is specified" do
    it "uses the specified method" do
      render_inline(described_class.new(href: "/path", icon: "test", text: "Hey There!", method: :delete))
      expect(page).to have_css "a[data-turbo-method='delete']"
    end
  end
end
