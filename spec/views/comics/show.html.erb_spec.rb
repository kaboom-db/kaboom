require "rails_helper"

RSpec.describe "comics/show", type: :view do
  before(:each) do
    assign(:comic, FactoryBot.create(:comic, name: "Demon Slayer"))
    assign(:ordered_issues, Issue.page(1).per(1))
  end

  it "renders attributes in <p>" do
    render
    assert_select "h1.text-2xl", text: "Demon Slayer"
  end

  context "when user is signed in" do
    before do
      def view.user_signed_in? = true
    end

    it "renders the batch read issues section" do
      render
      assert_select "summary.font-bold", text: "Batch read issues"
    end
  end

  context "when the user is not signed in" do
    before do
      def view.user_signed_in? = false
    end

    it "does not render the batch read issues section" do
      render
      assert_select "summary.font-bold", text: "Batch read issues", count: 0
    end
  end
end
