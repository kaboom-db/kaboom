require "rails_helper"

RSpec.describe "comics/index", type: :view do
  before(:each) do
    assign(:comics, [
      FactoryBot.create(:comic, cv_id: 1),
      FactoryBot.create(:comic, cv_id: 2)
    ])
  end

  it "renders a list of comics" do
    render
    skip("Add some specs")
  end
end
