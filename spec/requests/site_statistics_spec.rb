require "rails_helper"

RSpec.describe "SiteStatistics", type: :request do
  describe "GET /index" do
    it "renders the all the current site stats" do
      stats = [
        "Site visits:",
        "Accounts created:",
        "Comics imported:",
        "Issues imported:"
      ]
      get site_statistics_path
      stats.each do |stat|
        assert_select "h2.text-2xl", text: stat
      end
      assert_select "p.text-xl", text: "Comics"
      assert_select "p.text-xl", text: "Users"
    end
  end
end
