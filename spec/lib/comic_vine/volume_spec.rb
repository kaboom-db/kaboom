# frozen_string_literal: true

require "rails_helper"

module ComicVine
  RSpec.describe Volume do
    describe "#retrieve" do
      context "when API request succeeds" do
        let(:body) {
          {
            results: "Hello world."
          }.to_json
        }

        include_context "stub ComicVine API request" do
          let(:options) {
            {
              field_list: "id,aliases,api_detail_url,count_of_issues,date_last_updated,deck,description,image,name,publisher,site_detail_url,start_year,created_at,updated_at"
            }
          }
          let(:endpoint) { "volume/4050-123/" }
          let(:response) { {status: 200, body:} }
        end

        it "returns valid json" do
          expect(Volume.new(id: 123).retrieve).to eq({results: "Hello world."})
        end
      end

      context "when API request fails" do
        include_context "stub ComicVine API request" do
          let(:options) {
            {
              field_list: "id,aliases,api_detail_url,count_of_issues,date_last_updated,deck,description,image,name,publisher,site_detail_url,start_year,created_at,updated_at"
            }
          }
          let(:endpoint) { "volume/4050-123/" }
          let(:response) { {status: 404} }
        end

        it "returns nil" do
          expect(Volume.new(id: 123).retrieve).to eq nil
        end
      end
    end
  end
end
