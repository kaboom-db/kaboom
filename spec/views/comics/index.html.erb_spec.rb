require 'rails_helper'

RSpec.describe "comics/index", type: :view do
  before(:each) do
    assign(:comics, [
      Comic.create!(
        aliases: "Aliases",
        api_detail_url: "Api Detail Url",
        issue_count: 2,
        summary: "Summary",
        description: "Description",
        cv_id: 3,
        cover_image: "Cover Image",
        name: "Name",
        start_year: 4
      ),
      Comic.create!(
        aliases: "Aliases",
        api_detail_url: "Api Detail Url",
        issue_count: 2,
        summary: "Summary",
        description: "Description",
        cv_id: 3,
        cover_image: "Cover Image",
        name: "Name",
        start_year: 4
      )
    ])
  end

  it "renders a list of comics" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Aliases".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Api Detail Url".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Summary".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Description".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(3.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Cover Image".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(4.to_s), count: 2
  end
end
