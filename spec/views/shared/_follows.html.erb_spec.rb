require "rails_helper"

RSpec.describe "shared/activity", type: :view do
  let(:target) { FactoryBot.create(:user) }
  let(:follower1) { FactoryBot.create(:user, username: "Follow1") }
  let(:follower2) { FactoryBot.create(:user, username: "Follow2") }
  let(:follow1) { FactoryBot.create(:follow, target:, follower: follower1) }
  let(:follow2) { FactoryBot.create(:follow, target:, follower: follower2) }
  let(:follows) { [follower1, follower2] }

  def perform
    render "shared/follows", follows:, type: "followers", href: load_more_followers_user_path(target), page: 1
  end

  before do
    stub_const("UsersController::FOLLOWS_PER_PAGE", 2)
  end

  it "renders the follows and a link to load more" do
    perform
    assert_select "p", text: "Follow1"
    assert_select "p", text: "Follow2"
    assert_select "a[href='#{load_more_followers_user_path(target, page: 2)}']", text: "Load more"
  end

  it "renders a turbo frame" do
    perform
    assert_select "turbo-frame[id='followers']"
  end

  context "when follows count is less than the per_page defined" do
    let(:follows) { [follower1] }

    it "does not render a link to load more" do
      perform
      assert_select "a", text: "Load more", count: 0
    end
  end
end
