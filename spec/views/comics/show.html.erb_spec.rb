require "rails_helper"

RSpec.describe "comics/show", type: :view do
  before(:each) do
    assign(:comic, FactoryBot.create(:comic))
  end

  it "renders attributes in <p>" do
    render
    skip("Add some specs")
  end
end
