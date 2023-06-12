require 'rails_helper'

RSpec.describe "comics/show", type: :view do
  before(:each) do
    assign(:comic, Comic.create!(
      aliases: "Aliases",
      api_detail_url: "Api Detail Url",
      issue_count: 2,
      summary: "Summary",
      description: "Description",
      cv_id: 3,
      cover_image: "Cover Image",
      name: "Name",
      start_year: 4
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Aliases/)
    expect(rendered).to match(/Api Detail Url/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Summary/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/Cover Image/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/4/)
  end
end
