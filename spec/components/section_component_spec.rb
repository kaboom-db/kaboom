# frozen_string_literal: true

require "rails_helper"

RSpec.describe SectionComponent, type: :component do
  it "renders the component with specified content" do
    render_inline(described_class.new) { "Hey View Component" }
    expect(page).to have_content "Hey View Component"
  end
end
