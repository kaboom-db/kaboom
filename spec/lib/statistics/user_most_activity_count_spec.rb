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
      before do
        @comic1 = FactoryBot.create(:comic)
        @issue1, @issue2, @issue3, @issue4, @issue5 = FactoryBot.create_list(:issue, 5, comic: @comic1)
        @comic2 = FactoryBot.create(:comic)
        @issue6, @issue7, @issue8, @issue9, @issue10 = FactoryBot.create_list(:issue, 5, comic: @comic2)
        @comic3 = FactoryBot.create(:comic)
        @issue11, @issue12, @issue13, @issue14, @issue15 = FactoryBot.create_list(:issue, 5, comic: @comic3)
        @comic4 = FactoryBot.create(:comic)
        @issue16, @issue17, @issue18, @issue19, @issue20 = FactoryBot.create_list(:issue, 5, comic: @comic4)
        @comic5 = FactoryBot.create(:comic)
        @issue21, @issue22, @issue23, @issue24, @issue25 = FactoryBot.create_list(:issue, 5, comic: @comic5)
        @comic6 = FactoryBot.create(:comic)
        @issue26, @issue27, @issue28, @issue29, @issue30 = FactoryBot.create_list(:issue, 5, comic: @comic6)
      end

      def create_collection(date)
        FactoryBot.create(:collected_issue, collected_on: date, issue: @issue1, user:)
        FactoryBot.create(:collected_issue, collected_on: date, issue: @issue2, user:)
        FactoryBot.create(:collected_issue, collected_on: date, issue: @issue3, user:)

        FactoryBot.create(:collected_issue, collected_on: date, issue: @issue6, user:)

        FactoryBot.create(:collected_issue, collected_on: date, issue: @issue11, user:)
        FactoryBot.create(:collected_issue, collected_on: date, issue: @issue13, user:)

        FactoryBot.create(:collected_issue, collected_on: date - 1.year, issue: @issue17, user:)
        FactoryBot.create(:collected_issue, collected_on: date, issue: @issue18, user:)
        FactoryBot.create(:collected_issue, collected_on: date, issue: @issue19, user:)
        FactoryBot.create(:collected_issue, collected_on: date, issue: @issue20, user:)

        FactoryBot.create(:collected_issue, collected_on: date, issue: @issue21, user:)
        FactoryBot.create(:collected_issue, collected_on: date, issue: @issue22, user:)
        FactoryBot.create(:collected_issue, collected_on: date, issue: @issue23, user:)
        FactoryBot.create(:collected_issue, collected_on: date, issue: @issue24, user:)

        # Not included
        FactoryBot.create(:collected_issue, collected_on: date, issue: @issue26, user: FactoryBot.create(:user))
        FactoryBot.create(:collected_issue, collected_on: date, issue: @issue27, user: FactoryBot.create(:user))
        FactoryBot.create(:collected_issue, collected_on: date, issue: @issue28, user: FactoryBot.create(:user))
        FactoryBot.create(:collected_issue, collected_on: date, issue: @issue29, user: FactoryBot.create(:user))
        FactoryBot.create(:collected_issue, collected_on: date, issue: @issue30, user: FactoryBot.create(:user))
      end

      context "when year is alltime" do
        let(:year) { BaseCount::ALLTIME }

        it "returns the top 5 most collected comics of alltime for the user" do
          create_collection(Time.current.to_date)

          collected = count.collected
          expect(collected).to eq [@comic4, @comic5, @comic1, @comic3, @comic2]
          expect(collected.first.activity_count).to eq 4
          expect(collected.second.activity_count).to eq 4
          expect(collected.third.activity_count).to eq 3
          expect(collected.fourth.activity_count).to eq 2
          expect(collected.fifth.activity_count).to eq 1
        end
      end

      context "when year is a year" do
        let(:year) { 2024 }

        it "returns the top 5 most collected comics in that year for the user" do
          create_collection(Date.new(2024, 2, 2))

          collected = count.collected
          expect(collected).to eq [@comic5, @comic1, @comic4, @comic3, @comic2]
          expect(collected.first.activity_count).to eq 4
          expect(collected.second.activity_count).to eq 3
          expect(collected.third.activity_count).to eq 3
          expect(collected.fourth.activity_count).to eq 2
          expect(collected.fifth.activity_count).to eq 1
        end
      end
    end
  end
end
