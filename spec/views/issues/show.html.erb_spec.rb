require "rails_helper"

RSpec.describe "issues/show", type: :view do
  before(:each) do
    comic = FactoryBot.create(:comic)
    assign(:comic, comic)
    assign(:issue, FactoryBot.create(:issue, comic:, name: "Test Issue"))
  end

  it "renders attributes" do
    render
    assert_select "h1.text-2xl", text: "Test Issue"
  end
end
