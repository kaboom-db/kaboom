require "rails_helper"

RSpec.describe "Pages", type: :request do
  describe "GET /index" do
    it "renders a successful response" do
      get root_path
      expect(response).to be_successful
    end
  end
end
