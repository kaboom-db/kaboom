require 'rails_helper'

RSpec.describe "comics/new", type: :view do
  before(:each) do
    assign(:comic, Comic.new(
      aliases: "MyString",
      api_detail_url: "MyString",
      issue_count: 1,
      summary: "MyString",
      description: "MyString",
      cv_id: 1,
      cover_image: "MyString",
      name: "MyString",
      start_year: 1
    ))
  end

  it "renders new comic form" do
    render

    assert_select "form[action=?][method=?]", comics_path, "post" do

      assert_select "input[name=?]", "comic[aliases]"

      assert_select "input[name=?]", "comic[api_detail_url]"

      assert_select "input[name=?]", "comic[issue_count]"

      assert_select "input[name=?]", "comic[summary]"

      assert_select "input[name=?]", "comic[description]"

      assert_select "input[name=?]", "comic[cv_id]"

      assert_select "input[name=?]", "comic[cover_image]"

      assert_select "input[name=?]", "comic[name]"

      assert_select "input[name=?]", "comic[start_year]"
    end
  end
end
