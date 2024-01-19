require "rails_helper"

RSpec.describe "comics/index", type: :view do
  before do
    comic_1 = FactoryBot.create(:comic, name: "Berserk", cv_id: 1, start_year: nil)
    comic_2 = FactoryBot.create(:comic, name: "Spider-Man", cv_id: 2, start_year: nil)
    comic_3 = FactoryBot.create(:comic, name: "Demon Slayer", cv_id: 3, start_year: nil)
    comic_4 = FactoryBot.create(:comic, name: "Spy x Family", cv_id: 4, start_year: nil)

    assign(:recently_updated, [
      comic_1,
      comic_2
    ])

    assign(:trending, [
      comic_3,
      comic_4
    ])

    assign(:recently_updated_issues, [
      FactoryBot.create(:issue, comic: comic_1, issue_number: 1, name: "Issue #1", store_date: nil),
      FactoryBot.create(:issue, comic: comic_1, issue_number: 2, name: "Issue #2", store_date: nil)
    ])

    assign(:trending_issues, [
      FactoryBot.create(:issue, comic: comic_1, issue_number: 3, name: "Issue #3", store_date: nil),
      FactoryBot.create(:issue, comic: comic_1, issue_number: 4, name: "Issue #4", store_date: nil)
    ])

    render
  end

  it "renders recently updated comics" do
    assert_select "small", text: "Berserk"
    assert_select "small", text: "Spider-Man"
  end

  it "renders recently updated comics" do
    assert_select "small", text: "Issue #1"
    assert_select "small", text: "Issue #2"
  end

  it "renders the trending comics" do
    assert_select "a.text-2xl", text: "Demon Slayer"
    assert_select "a.text-2xl", text: "Spy x Family"
  end

  it "renders the trending issues" do
    assert_select "a.text-2xl", text: "Issue #3"
    assert_select "a.text-2xl", text: "Issue #4"
  end
end
