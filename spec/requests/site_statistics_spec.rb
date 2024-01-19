require "rails_helper"

RSpec.describe "SiteStatistics", type: :request do
  describe "GET /index" do
    it "renders the all the current site stats" do
      stats = [
        "Site visits",
        "Accounts created",
        "Comics imported",
        "Issues imported"
      ]
      get site_statistics_path
      stats.each do |stat|
        assert_select "h3.text-2xl", text: stat
      end
    end
  end
end
