require "rails_helper"

RSpec.describe IssuesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "comics/1/issues").to route_to("issues#index", comic_id: "1")
    end

    it "routes to #show" do
      expect(get: "comics/1/issues/1").to route_to("issues#show", id: "1", comic_id: "1")
    end
  end
end
