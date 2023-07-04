require "rails_helper"

RSpec.describe "comics/index", type: :view do
  before(:each) do
    comic_1 = FactoryBot.create(:comic, name: "Berserk", cv_id: 1)
    comic_2 = FactoryBot.create(:comic, name: "Spider-Man", cv_id: 2)
    comic_3 = FactoryBot.create(:comic, name: "Demon Slayer", cv_id: 3)
    comic_4 = FactoryBot.create(:comic, name: "Spy x Family", cv_id: 4)

    assign(:recently_updated, [
      comic_1,
      comic_2
    ])

    assign(:trending, [
      comic_3,
      comic_4
    ])

    assign(:recently_updated_issues, [
      FactoryBot.create(:issue, comic: comic_1, issue_number: 1),
      FactoryBot.create(:issue, comic: comic_1, issue_number: 2)
    ])

    assign(:trending_issues, [
      FactoryBot.create(:issue, comic: comic_1, issue_number: 3),
      FactoryBot.create(:issue, comic: comic_1, issue_number: 4)
    ])
  end

  # TODO: Add better specs
  it "renders a list of comics" do
    render
    assert_select "small", text: "Berserk"
    assert_select "small", text: "Spider-Man"
  end
end
