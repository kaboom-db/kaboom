require "rails_helper"

RSpec.describe "comics/show", type: :view do
  let(:comic) { FactoryBot.create(:comic, name: "Demon Slayer", genres: [FactoryBot.create(:genre, name: "Action", fa_icon: "fa-action")], description:) }
  let(:description) { "Some long description" }

  before(:each) do
    assign(:comic, comic)
    assign(:ordered_issues, Issue.paginate(page: 1, per_page: 1))
  end

  it "renders attributes in <p>" do
    render
    assert_select "h1.text-2xl", text: "Demon Slayer"
    assert_select "div.flex", text: "Some long description"
  end

  it "renders the genres" do
    render
    assert_select "p.uppercase", text: "Action"
    assert_select "i.fa-action"
  end

  context "when comic has no description" do
    let(:description) { "" }

    it "renders text to hint at ComicVine" do
      render
      assert_select "div.flex", text: "There is no description for this comic yet. Head over to ComicVine and add one!"
    end
  end

  context "when user is signed in and comic has issues" do
    before do
      def view.user_signed_in? = true
      FactoryBot.create(:issue, comic:)
    end

    it "renders the batch read issues section" do
      render
      assert_select "summary.font-bold", text: "Batch read issues"
    end
  end

  context "when user is signed in and comic has no issues" do
    before do
      def view.user_signed_in? = true
    end

    it "does not render the batch read issues section" do
      render
      assert_select "summary.font-bold", text: "Batch read issues", count: 0
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

  context "when comic has no issues" do
    it "renders text stating that no issues are released" do
      render
      assert_select "div", text: "No issues have been released yet!"
    end
  end

  context "when comic has issues" do
    it "does not render text stating that no issues are released" do
      FactoryBot.create(:issue, comic:)
      render
      assert_select "div", text: "No issues have been released yet!", count: 0
    end
  end
end
