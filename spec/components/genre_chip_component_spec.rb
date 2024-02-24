# frozen_string_literal: true

require "rails_helper"

RSpec.describe GenreChipComponent, type: :component do
  it "renders the component" do
    genre = FactoryBot.create(:genre, name: "Action")
    render_inline(described_class.new(genre:))
    expect(page).to have_content "Action"
  end
end
