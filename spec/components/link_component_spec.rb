# frozen_string_literal: true

require "rails_helper"

RSpec.describe LinkComponent, type: :component do
  it "renders the component with specified href and text" do
    render_inline(described_class.new(href: "/link/to/page", text: "I'm a link"))
    expect(page).to have_link href: "/link/to/page", text: "I'm a link"
  end
end
