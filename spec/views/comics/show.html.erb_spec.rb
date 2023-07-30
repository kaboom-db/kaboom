require "rails_helper"

RSpec.describe "comics/show", type: :view do
  before(:each) do
    assign(:comic, FactoryBot.create(:comic, name: "Demon Slayer"))
  end

  it "renders attributes in <p>" do
    render
    assert_select "h1.text-4xl", text: "Demon Slayer"
  end
end
