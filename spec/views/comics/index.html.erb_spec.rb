require "rails_helper"

RSpec.describe "comics/index", type: :view do
  before(:each) do
    assign(:recently_updated, [
      FactoryBot.create(:comic, name: "Berserk", cv_id: 1),
      FactoryBot.create(:comic, name: "Spider-Man", cv_id: 2)
    ])

    assign(:trending, [
      FactoryBot.create(:comic, name: "Demon Slayer", cv_id: 3),
      FactoryBot.create(:comic, name: "Spy x Family", cv_id: 4)
    ])
  end

  it "renders a list of comics" do
    render
    assert_select "small", text: "Berserk"
    assert_select "small", text: "Spider-Man"
  end
end
