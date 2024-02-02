# frozen_string_literal: true

require "rails_helper"

RSpec.describe Forms::CollectionSelectComponent, type: :component do
  it "renders a select field for a form" do
    comic = Comic.new
    view = ActionView::Base.empty
    form = ActionView::Helpers::FormBuilder.new(:comic, comic, view, {})
    render_inline(described_class.new(form:, field: :comic_type, options: Comic::TYPES))
    expect(page).to have_css "select"
    Comic::TYPES.each do |type|
      expect(page).to have_css("option", text: type)
    end
  end

  context "when multiple is true" do
    it "renders a multi select field for a form" do
      comic = Comic.new
      view = ActionView::Base.empty
      form = ActionView::Helpers::FormBuilder.new(:comic, comic, view, {})
      render_inline(described_class.new(form:, field: :comic_type, options: Comic::TYPES, multiple: true))
      expect(page).to have_css "select[multiple]"
      expect(page).to have_content "Click to select an option, Control + Click to deselect one"
    end
  end
end