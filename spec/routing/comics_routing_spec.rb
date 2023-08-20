require "rails_helper"

RSpec.describe ComicsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/comics").to route_to("comics#index")
    end

    it "routes to #show" do
      expect(get: "/comics/1").to route_to("comics#show", id: "1")
    end

    it "routes to #import" do
      expect(post: "/comics/import").to route_to("comics#import")
    end

    it "routes to #wishlist" do
      expect(post: "/comics/1/wishlist").to route_to("comics#wishlist", id: "1")
    end

    it "routes to #unwishlist" do
      expect(post: "/comics/1/unwishlist").to route_to("comics#unwishlist", id: "1")
    end
  end
end
