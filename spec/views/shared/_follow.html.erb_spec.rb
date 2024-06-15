require "rails_helper"

RSpec.describe "shared/activity", type: :view do
  let(:user) { FactoryBot.create(:user, username: "BobMan") }

  def perform
    render "shared/follow", user:
  end

  it "renders the profile component" do
    perform
    assert_select "p", text: "BobMan"
    assert_select "a[href='#{user_path(user)}']"
  end
end
