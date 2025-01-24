require "rails_helper"

RSpec.describe "issues/show", type: :view do
  before(:each) do
    comic = FactoryBot.create(:comic)
    @issue = FactoryBot.create(:issue, comic:, name: "Test Issue")
    assign(:comic, comic)
    assign(:issue, @issue)
    assign(:rating_presenter, RatingPresenter.new(resource: @issue))
  end

  it "renders attributes" do
    render
    assert_select "h1.text-2xl", text: "Test Issue"
  end

  it "renders the refresh button" do
    render
    assert_select "button", text: "Refresh"
  end

  it "renders the rating section" do
    FactoryBot.create(:review, reviewable: @issue, title: "This is a review")
    render
    assert_select "b.text-lg", text: "This is a review"
  end
end
