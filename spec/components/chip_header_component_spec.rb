# frozen_string_literal: true

require "rails_helper"

RSpec.describe ChipHeaderComponent, type: :component do
  it "renders the component with specified text" do
    render_inline(described_class.new(text: "Hello there"))
    expect(page).to have_content "Hello there"
  end
end
