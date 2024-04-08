require "rails_helper"

RSpec.describe "shared/activity", type: :view do
  let(:user) { FactoryBot.create(:user, username: "BobMan") }
  let(:comic) { FactoryBot.create(:comic, name: "Amazing Comic") }
  let(:issue) { FactoryBot.create(:issue, comic:, issue_number: "1", name: "Amazing Issue", image: "/path/to/image.jpg") }
  let(:read_at) { DateTime.new(2024, 1, 1, 10) }
  let(:record) { ReadIssue.new(user:, issue:, read_at:) }
  let(:activity) { Social::ReadActivity.new(record:) }

  def perform
    render "shared/activity", activity: activity
  end

  it "renders the content and timestamp" do
    perform
    assert_select "p", text: "BobMan read Issue #1 of Amazing Comic (Amazing Issue)"
    assert_select "small", text: "2024-01-01 10:00:00 UTC"
  end

  context "when image is present" do
    it "renders the image" do
      perform
      assert_select "img[src='/path/to/image.jpg']"
    end

    context "when link is present" do
      it "renders a link to the item" do
        perform
        assert_select "a[href='#{comic_issue_path(issue, comic_id: comic)}']"
      end
    end

    context "when link is not present" do
      it "does not render a link" do
        allow(activity).to receive(:link).and_return(nil)
        perform
        assert_select "a", count: 0
      end
    end
  end

  context "when image is not present" do
    it "does not render an image" do
      allow(activity).to receive(:image).and_return(nil)
      perform
      assert_select "img", count: 0
    end
  end
end
