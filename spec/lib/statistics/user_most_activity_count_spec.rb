# frozen_string_literal: true

require "rails_helper"

module Statistics
  RSpec.describe UserMostActivityCount do
    let(:user) { FactoryBot.create(:user) }
    let(:count) { UserMostActivityCount.new(year:, user:) }

    describe "#read" do
      before do
        @comic1 = FactoryBot.create(:comic)
        @issue1 = FactoryBot.create(:issue, comic: @comic1)
        @comic2 = FactoryBot.create(:comic)
        @issue2 = FactoryBot.create(:issue, comic: @comic2)
        @comic3 = FactoryBot.create(:comic)
        @issue3 = FactoryBot.create(:issue, comic: @comic3)
        @comic4 = FactoryBot.create(:comic)
        @issue4 = FactoryBot.create(:issue, comic: @comic4)
        @comic5 = FactoryBot.create(:comic)
        @issue5 = FactoryBot.create(:issue, comic: @comic5)
        @comic6 = FactoryBot.create(:comic)
        @issue6 = FactoryBot.create(:issue, comic: @comic6)
      end

      context "when year is alltime" do
        let(:year) { BaseCount::ALLTIME }

        it "returns the top 5 most read comics of alltime for the user" do
          FactoryBot.create_list(:read_issue, 3, read_at: Time.current, issue: @issue1, user:)
          FactoryBot.create(:read_issue, read_at: Time.current + 2.seconds, issue: @issue1, user:) # Not included as in the future
          FactoryBot.create_list(:read_issue, 5, read_at: Time.current - 1.year, issue: @issue2, user:)
          FactoryBot.create_list(:read_issue, 2, read_at: Time.current - 3.years, issue: @issue3, user:)
          FactoryBot.create_list(:read_issue, 6, read_at: Time.current - 1.day, issue: @issue4, user:)
          FactoryBot.create_list(:read_issue, 4, read_at: Time.current, issue: @issue5, user:)
          FactoryBot.create_list(:read_issue, 7, read_at: Time.current, issue: @issue6, user:)
          FactoryBot.create(:read_issue, read_at: Time.current, issue: @issue6, user: FactoryBot.create(:user)) # Not included as different user

          read = count.read
          expect(read).to eq [@comic6, @comic4, @comic2, @comic5, @comic1]
          expect(read.first.activity_count).to eq 7
          expect(read.second.activity_count).to eq 6
          expect(read.third.activity_count).to eq 5
          expect(read.fourth.activity_count).to eq 4
          expect(read.fifth.activity_count).to eq 3
        end
      end

      context "when year is a year" do
        let(:year) { 2024 }

        it "returns up to the top 5 most read comics in that year for the user" do
          date = Date.new(2024, 2, 2)
          FactoryBot.create_list(:read_issue, 3, read_at: date.end_of_year + 1.day, issue: @issue1, user:)
          FactoryBot.create_list(:read_issue, 2, read_at: date.beginning_of_year - 1.second, issue: @issue2, user:) # Not included
          FactoryBot.create(:read_issue, read_at: date + 1.second, issue: @issue2, user:)
          FactoryBot.create_list(:read_issue, 5, read_at: date.beginning_of_year, issue: @issue3, user:)
          FactoryBot.create_list(:read_issue, 6, read_at: date, issue: @issue4, user:)
          FactoryBot.create_list(:read_issue, 4, read_at: date, issue: @issue5, user:)
          FactoryBot.create_list(:read_issue, 7, read_at: date, issue: @issue6, user:)
          FactoryBot.create(:read_issue, read_at: date, issue: @issue6, user: FactoryBot.create(:user)) # Not included as different user

          read = count.read
          expect(read).to eq [@comic6, @comic4, @comic3, @comic5, @comic2]
          expect(read.first.activity_count).to eq 7
          expect(read.second.activity_count).to eq 6
          expect(read.third.activity_count).to eq 5
          expect(read.fourth.activity_count).to eq 4
          expect(read.fifth.activity_count).to eq 1
        end
      end
    end

    describe "#collected" do
      # TODO: Add specs
      pending "Add some specs"
    end
  end
end
