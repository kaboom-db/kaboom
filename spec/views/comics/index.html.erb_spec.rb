require "rails_helper"

RSpec.describe "comics/index", type: :view do
  before(:each) do
    assign(:comics, [
      FactoryBot.create(:comic, name: "Berserk", cv_id: 1),
      FactoryBot.create(:comic, name: "Spider-Man", cv_id: 2)
    ])
  end

  it "renders a list of comics" do
    render
    assert_select "small", text: "Berserk"
    assert_select "small", text: "Spider-Man"
  end
end
