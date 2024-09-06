# frozen_string_literal: true

require "rails_helper"

RSpec.describe Charts::StackedChartComponent, type: :component do
  context "when there is data present" do
    let(:data) {
      [
        {
          name: "Action",
          percentage: 50,
          count: 2
        },
        {
          name: "Comedy",
          percentage: 50,
          count: 2
        }
      ]
    }

    it "renders the chart segments" do
      render_inline(Charts::StackedChartComponent.new(data:, title: "Issues read by genre", type: "issues"))
      expect(page).to have_css "div[data-name='Action']"
      expect(page).to have_css "div[data-name='Comedy']"
      expect(page).to have_css "div[style='width: 50%; background-color: rgb(#{Charts::Constants::CHART_COLOURS.first});']"
      expect(page).to have_css "div[style='width: 50%; background-color: rgb(#{Charts::Constants::CHART_COLOURS.second});']"
      expect(page).to have_css "div[data-percentage='50']", count: 2
      expect(page).to have_css "div[data-count='2']", count: 2
    end

    it "renders the title" do
      render_inline(Charts::StackedChartComponent.new(data:, title: "Issues read by genre", type: "issues"))
      expect(page).to have_content "Issues read by genre:"
    end

    it "renders the subtitle" do
      render_inline(Charts::StackedChartComponent.new(data:, title: "Issues read by genre", type: "issues"))
      expect(page).to have_content "Action"
      expect(page).to have_content "50% - 2\n        \n        issues"
    end
  end

  context "when there is no data present" do
    let(:data) { [] }

    it "does not render anything" do
      render_inline(Charts::StackedChartComponent.new(data:, title: "Issues read by genre", type: "issues"))
      expect(page).not_to have_content "Issues read by genre:"
    end
  end
end
