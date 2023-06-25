# frozen_string_literal: true

require "rails_helper"

module ComicVine
  RSpec.describe VolumeIssues do
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
              field_list: "aliases,api_detail_url,cover_date,date_last_updated,deck,description,id,image,issue_number,name,site_detail_url,store_date,volume",
              filter: "volume:123"
            }
          }
          let(:endpoint) { "issues/" }
          let(:response) { {status: 200, body:} }
        end

        it "returns valid json" do
          expect(VolumeIssues.new(volume_id: 123).retrieve).to eq({results: "Hello world."})
        end
      end

      context "when API request fails" do
        include_context "stub ComicVine API request" do
          let(:options) {
            {
              field_list: "aliases,api_detail_url,cover_date,date_last_updated,deck,description,id,image,issue_number,name,site_detail_url,store_date,volume",
              filter: "volume:123"
            }
          }
          let(:endpoint) { "issues/" }
          let(:response) { {status: 404} }
        end

        it "returns nil" do
          expect(VolumeIssues.new(volume_id: 123).retrieve).to eq nil
        end
      end
    end
  end
end
