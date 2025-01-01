# frozen_string_literal: true

require "rails_helper"

RSpec.describe FullWidthComponent, type: :component do
  it "renders content" do
    render_inline(FullWidthComponent.new) { "Hello, components!" }
    expect(page).to have_content "Hello, components!"
  end

  it "renders extra classes" do
    render_inline(FullWidthComponent.new(extra_classes: ["new-class"])) { "Hello, components!" }
    expect(page).to have_css "div.new-class"
  end

  it "renders data attributes" do
    render_inline(FullWidthComponent.new(data: {key: "value"})) { "Hello, components!" }
    expect(page).to have_css "div[data-key='value']"
  end
end
