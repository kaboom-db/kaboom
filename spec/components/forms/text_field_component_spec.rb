# frozen_string_literal: true

require "rails_helper"

RSpec.describe Forms::TextFieldComponent, type: :component do
  it "renders a text field for a form" do
    user = User.new
    view = ActionView::Base.empty
    form = ActionView::Helpers::FormBuilder.new(:user, user, view, {})
    render_inline(described_class.new(form:, field: :email, type: "text_field"))
    expect(page).to have_css "input[type='text'][placeholder='Email']"
  end

  it "renders an email field for a form" do
    user = User.new
    view = ActionView::Base.empty
    form = ActionView::Helpers::FormBuilder.new(:user, user, view, {})
    render_inline(described_class.new(form:, field: :email, type: "email_field"))
    expect(page).to have_css "input[type='email'][placeholder='Email']"
  end

  it "renders a password field for a form" do
    user = User.new
    view = ActionView::Base.empty
    form = ActionView::Helpers::FormBuilder.new(:user, user, view, {})
    render_inline(described_class.new(form:, field: :password, type: "password_field"))
    expect(page).to have_css "input[type='password'][placeholder='Password']"
  end

  it "renders a number field for a form" do
    user = User.new
    view = ActionView::Base.empty
    form = ActionView::Helpers::FormBuilder.new(:user, user, view, {})
    render_inline(described_class.new(form:, field: :password, type: "number_field"))
    expect(page).to have_css "input[type='number'][placeholder='Password']"
  end

  it "renders a custom placeholder" do
    user = User.new
    view = ActionView::Base.empty
    form = ActionView::Helpers::FormBuilder.new(:user, user, view, {})
    render_inline(described_class.new(form:, field: :password, type: "number_field", placeholder: "Custom"))
    expect(page).to have_css "input[type='number'][placeholder='Custom']"
  end

  it "renders extra arguments" do
    user = User.new
    view = ActionView::Base.empty
    form = ActionView::Helpers::FormBuilder.new(:user, user, view, {})
    render_inline(described_class.new(form:, field: :password, type: "number_field", extras: {step: ".01"}))
    expect(page).to have_css "input[type='number'][step='.01']"
  end

  it "can be required" do
    user = User.new
    view = ActionView::Base.empty
    form = ActionView::Helpers::FormBuilder.new(:user, user, view, {})
    render_inline(described_class.new(form:, field: :password, type: "password_field", required: true))
    expect(page).to have_css "input[type='password'][placeholder='Password'][required='required']"
  end

  it "can be autofocused" do
    user = User.new
    view = ActionView::Base.empty
    form = ActionView::Helpers::FormBuilder.new(:user, user, view, {})
    render_inline(described_class.new(form:, field: :password, type: "password_field", autofocus: true))
    expect(page).to have_css "input[type='password'][placeholder='Password'][autofocus='autofocus']"
  end
end
