require "rails_helper"

RSpec.describe "shared/load_more_activities_link", type: :view do
  it "renders a link to load more activities" do
    render "shared/load_more_activities_link", href: dashboard_load_more_activities_path, page: 1
    assert_select "a", text: "Load more"
    expect(rendered).to have_css("a[href='#{dashboard_load_more_activities_path(page: 2)}']")
    expect(rendered).to have_css("a[data-turbo-stream='true']")
  end
end
