require "rails_helper"

RSpec.describe DashboardController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/dashboard").to route_to("dashboard#index")
    end

    it "routes to #history" do
      expect(get: "/dashboard/history").to route_to("dashboard#history")
    end
  end
end
