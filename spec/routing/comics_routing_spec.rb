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

    it "routes to #favourite" do
      expect(post: "/comics/1/favourite").to route_to("comics#favourite", id: "1")
    end

    it "routes to #unfavourite" do
      expect(post: "/comics/1/unfavourite").to route_to("comics#unfavourite", id: "1")
    end

    it "routes to #read_range" do
      expect(post: "/comics/1/read_range").to route_to("comics#read_range", id: "1")
    end

    it "routes to #refresh" do
      expect(post: "/comics/1/refresh").to route_to("comics#refresh", id: "1")
    end

    it "routes to #read_next_issue" do
      expect(post: "/comics/1/read_next_issue").to route_to("comics#read_next_issue", id: "1")
    end
  end
end
