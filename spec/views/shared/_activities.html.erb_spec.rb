require "rails_helper"

RSpec.describe "shared/activity", type: :view do
  let(:user) { FactoryBot.create(:user, username: "BobMan") }
  let(:comic) { FactoryBot.create(:comic, name: "Amazing Comic") }
  let(:issue) { FactoryBot.create(:issue, comic:, issue_number: "1", name: "Amazing Issue", image: "/path/to/image.jpg") }
  let(:read_at) { DateTime.new(2024, 1, 1, 10) }
  let(:record) { ReadIssue.new(user:, issue:, read_at:) }
  let(:activity) { Social::ReadActivity.new(record:) }
  let(:activities) { [activity, activity] }

  def perform
    render "shared/activities", activities:, activities_load_more_path: dashboard_load_more_activities_path
  end

  before do
    assign(:page, 1)
    stub_const("Social::Feed::PER_PAGE", 2)
  end

  it "renders the activities and a link to load more" do
    perform
    assert_select "p", text: "BobMan read Issue #1 of Amazing Comic (Amazing Issue)", count: 2
    assert_select "a", text: "Load more"
  end

  context "when activities count is less than the per_page defined by Feed" do
    let(:activities) { [activity] }

    it "does not render a link to load more" do
      perform
      assert_select "a", text: "Load more", count: 0
    end
  end
end
