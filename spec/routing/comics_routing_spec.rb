require "rails_helper"

RSpec.describe ComicsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/comics").to route_to("comics#index")
    end

    it "routes to #new" do
      expect(get: "/comics/new").to route_to("comics#new")
    end

    it "routes to #show" do
      expect(get: "/comics/1").to route_to("comics#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/comics/1/edit").to route_to("comics#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/comics").to route_to("comics#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/comics/1").to route_to("comics#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/comics/1").to route_to("comics#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/comics/1").to route_to("comics#destroy", id: "1")
    end
  end
end
