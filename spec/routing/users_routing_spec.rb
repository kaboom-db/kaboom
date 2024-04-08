require "rails_helper"

RSpec.describe UsersController, type: :routing do
  describe "routing" do
    it "routes to #show" do
      expect(get: "/users/bob").to route_to("users#show", id: "bob")
    end

    it "routes to #load_more_activities" do
      expect(get: "/users/bob/load_more_activities").to route_to("users#load_more_activities", id: "bob")
    end
  end
end
