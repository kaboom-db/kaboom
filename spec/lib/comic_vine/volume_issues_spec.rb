# frozen_string_literal: true

require "rails_helper"

module ComicVine
  RSpec.describe VolumeIssues do
    describe "#retrieve" do
      def stub_cv(results:, volume_id:, offset:, status:)
        credentials = Rails.application.credentials.dig(:comic_vine)
        base_url = credentials[:url]
        api_key = credentials[:api_key]
        options = {
          api_key:,
          format: "json",
          field_list: "aliases,api_detail_url,cover_date,date_last_updated,deck,description,id,image,issue_number,name,site_detail_url,store_date,volume",
          filter: "volume:#{volume_id}",
          offset:
        }
        params = URI.encode_www_form(options).to_s
        stub_request(:get, "#{base_url}issues/?#{params}").to_return(status:, body: {results:}.to_json)
      end

      context "when the count of issues is less than 100" do
        before do
          stub_cv(results: ["hello", "there"], volume_id: 123, offset: 0, status: 200)
        end

        it "returns an array of results" do
          expect(VolumeIssues.new(volume_id: 123, count_of_issues: 99).retrieve).to eq(["hello", "there"])
        end
      end

      context "when all API requests succeed" do
        before do
          stub_cv(results: ["hello", "there"], volume_id: 123, offset: 0, status: 200)
          stub_cv(results: ["general", "kenobi!"], volume_id: 123, offset: 100, status: 200)
        end

        it "returns an array of results" do
          expect(VolumeIssues.new(volume_id: 123, count_of_issues: 106).retrieve).to eq(["hello", "there", "general", "kenobi!"])
        end
      end

      context "when an API request fails" do
        before do
          stub_cv(results: ["hello", "there"], volume_id: 123, offset: 0, status: 400)
          stub_cv(results: ["general", "kenobi!"], volume_id: 123, offset: 100, status: 200)
        end

        it "skips the failed response" do
          expect(VolumeIssues.new(volume_id: 123, count_of_issues: 199).retrieve).to eq ["general", "kenobi!"]
        end
      end

      context "when all API requests fail" do
        before do
          stub_cv(results: ["hello", "there"], volume_id: 123, offset: 0, status: 400)
          stub_cv(results: ["general", "kenobi!"], volume_id: 123, offset: 100, status: 400)
        end

        it "returns an empty array" do
          expect(VolumeIssues.new(volume_id: 123, count_of_issues: 106).retrieve).to eq([])
        end
      end
    end
  end
end
