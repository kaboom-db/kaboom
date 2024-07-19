require "rails_helper"

RSpec.describe "users/collection", type: :view do
  def perform(user)
    comic = FactoryBot.create(:comic, name: "Demon Slayer", count_of_issues: 2)
    issue1 = FactoryBot.create(:issue, comic:, name: "Issue 1", issue_number: 1)
    issue2 = FactoryBot.create(:issue, comic:, name: "Issue 2", issue_number: 2)
    @ci1 = FactoryBot.create(:collected_issue, issue: issue1, user:, price_paid: 10.99)
    @ci2 = FactoryBot.create(:collected_issue, issue: issue2, user:, price_paid: 10.99)
    presenter = UserCollectionPresenter.new(user:)

    render "users/collection", presenter:
  end

  context "when current user is the same as the user" do
    before do
      user = FactoryBot.create(:user)
      def view.current_user = User.first
      perform(user)
    end

    it "renders the comic and its collected issues" do
      assert_select "p", text: "Demon Slayer"
      assert_select "p", text: "#1 - Issue 1"
      assert_select "p", text: "#2 - Issue 2"
      assert_select "p", text: "10.99", count: 2
    end

    it "renders the totals" do
      assert_select "p", text: "21.98", count: 2 # One for Demon Slayer total, the other for overall total
      assert_select "p", text: "2 / 2", count: 2 # One for Demon Slayer total, the other for overall total
    end

    it "renders the dialog for editing the collected issue" do
      assert_select "dialog[data-dialog-toggler-id-value='toggleEditor#{@ci1.id}']"
      assert_select "dialog[data-dialog-toggler-id-value='toggleEditor#{@ci2.id}']"
    end
  end

  context "when user is not the current user" do
    before do
      user = FactoryBot.create(:user)
      def view.current_user = FactoryBot.create(:user)
      perform(user)
    end

    it "does not render any prices" do
      assert_select "p", text: "21.98", count: 0
      assert_select "p", text: "10.99", count: 0
    end

    it "does not render the dialog for editing the collected issue" do
      assert_select "dialog[data-dialog-toggler-id-value='toggleEditor#{@ci1.id}']", count: 0
      assert_select "dialog[data-dialog-toggler-id-value='toggleEditor#{@ci2.id}']", count: 0
    end
  end
end
