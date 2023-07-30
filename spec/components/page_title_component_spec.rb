# frozen_string_literal: true

require "rails_helper"

RSpec.describe PageTitleComponent, type: :component do
  it "renders the component with specified href and text" do
    render_inline(described_class.new(text: "Hey There!"))
    expect(page).to have_content "Hey There!"
  end
end
