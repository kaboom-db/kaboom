# frozen_string_literal: true

require "rails_helper"

RSpec.describe ResourceTileComponent, type: :component do
  context "when resource is a comic" do
    it "renders the resource's poster and name" do
      comic = FactoryBot.create(:comic, name: "Venom", start_year: 2018, image: "/path/to/image.jpg")
      render_inline(described_class.new(resource: comic, resource_path: "/path/to/comic/"))
      expect(page).to have_css "a[href='/path/to/comic/']"
      expect(page).to have_css "small", text: "Venom"
    end
  end

  context "when resource is an issue" do
    it "renders the resource's poster and name" do
      issue = FactoryBot.create(:issue, name: "Venom #1", issue_number: 10.1, image: "/path/to/image.jpg")
      render_inline(described_class.new(resource: issue, resource_path: "/path/to/issue/"))
      expect(page).to have_css "a[href='/path/to/issue/']"
      expect(page).to have_css "small", text: "Venom #1"
    end
  end
end
