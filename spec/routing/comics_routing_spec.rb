require "rails_helper"

RSpec.describe ComicsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/comics").to route_to("comics#index")
    end

    it "routes to #show" do
      expect(get: "/comics/1").to route_to("comics#show", id: "1")
    end
  end
end
