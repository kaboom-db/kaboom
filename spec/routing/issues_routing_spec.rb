require "rails_helper"

RSpec.describe IssuesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "comics/1/issues").to route_to("issues#index", comic_id: "1")
    end

    it "routes to #show" do
      expect(get: "comics/1/issues/1").to route_to("issues#show", id: "1", comic_id: "1")
    end

    it "routes to #read" do
      expect(post: "comics/1/issues/1/read").to route_to("issues#read", id: "1", comic_id: "1")
    end

    it "routes to #unread" do
      expect(post: "comics/1/issues/1/unread").to route_to("issues#unread", id: "1", comic_id: "1")
    end

    it "routes to #wishlist" do
      expect(post: "comics/1/issues/1/wishlist").to route_to("issues#wishlist", id: "1", comic_id: "1")
    end

    it "routes to #unwishlist" do
      expect(post: "comics/1/issues/1/unwishlist").to route_to("issues#unwishlist", id: "1", comic_id: "1")
    end

    it "routes to #favourite" do
      expect(post: "comics/1/issues/1/favourite").to route_to("issues#favourite", id: "1", comic_id: "1")
    end

    it "routes to #unfavourite" do
      expect(post: "comics/1/issues/1/unfavourite").to route_to("issues#unfavourite", id: "1", comic_id: "1")
    end

    it "routes to #collect" do
      expect(post: "comics/1/issues/1/collect").to route_to("issues#collect", id: "1", comic_id: "1")
    end

    it "routes to #uncollect" do
      expect(post: "comics/1/issues/1/uncollect").to route_to("issues#uncollect", id: "1", comic_id: "1")
    end

    it "routes to #reviews" do
      expect(get: "/comics/1/issues/1/reviews").to route_to("issues#reviews", id: "1", comic_id: "1")
    end

    it "routes to #rate" do
      expect(post: "/comics/1/issues/1/rate").to route_to("issues#rate", id: "1", comic_id: "1")
    end
  end
end
