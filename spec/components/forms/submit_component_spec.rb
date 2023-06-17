# frozen_string_literal: true

require "rails_helper"

RSpec.describe Forms::SubmitComponent, type: :component do
  it "renders a submit button for a form with specified text" do
    user = User.new
    view = ActionView::Base.empty
    form = ActionView::Helpers::FormBuilder.new(:user, user, view, {})
    render_inline(described_class.new(form:, text: "Submit me"))
    expect(page).to have_css "input[type='submit'][value='Submit me']"
  end
end
