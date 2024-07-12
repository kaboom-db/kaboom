# frozen_string_literal: true

require "rails_helper"

RSpec.describe RemoveItemDialogComponent, type: :component do
  it "the dialog with some custom content" do
    render_inline(RemoveItemDialogComponent.new) { "Hello, components!" }
    expect(page).to have_css "dialog[data-remove-item-target='dialog']"
    expect(page).to have_content "Hello, components!"
  end
end
