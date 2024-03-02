# frozen_string_literal: true

require "rails_helper"

RSpec.describe GenreChipComponent, type: :component do
  include Rails.application.routes.url_helpers

  it "renders the component" do
    genre = FactoryBot.create(:genre, name: "Action")
    render_inline(described_class.new(genre:))
    expect(page).to have_content "Action"
  end

  it "renders a link to the genre" do
    genre = FactoryBot.create(:genre, name: "Action")
    render_inline(described_class.new(genre:))
    expect(page).to have_link "Action", href: genre_path(genre)
  end
end
