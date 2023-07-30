require "rails_helper"

RSpec.describe "issues/index", type: :view do
  before(:each) do
    assign(:comic, FactoryBot.create(:comic))
  end

  it "renders a list of issues" do
    render
    assert_select "h1.text-4xl", text: "Issues"
  end
end
