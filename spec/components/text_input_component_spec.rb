# frozen_string_literal: true

require "rails_helper"

RSpec.describe TextInputComponent, type: :component do
  it "renders a text input" do
    render_inline(described_class.new(name: "Hey"))
    expect(page).to have_css "input[type='input'][placeholder='Hey'][name='Hey']"
  end
end
