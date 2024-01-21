class SiteStatisticsController < ApplicationController
  def index
    set_metadata(title: "Site Statistics", description: "Kaboom as a platform is growing every day with new features, comics and users. Check out how the site is performing!")

    site_visits = build_stats_hash(
      title: "Site visits",
      resource: Visit,
      num_of_elms: 30,
      type: Charts::ChartCountGenerator::LINE,
      range_type: Charts::ChartCountGenerator::DAY,
      rgb: Charts::ChartCountGenerator::VISIT
    )

    accounts_created = build_stats_hash(
      title: "Accounts created",
      resource: User,
      num_of_elms: 7,
      type: Charts::ChartCountGenerator::LINE,
      range_type: Charts::ChartCountGenerator::DAY,
      rgb: Charts::ChartCountGenerator::USER
    )

    comics_imported = build_stats_hash(
      title: "Comics imported",
      resource: Comic,
      num_of_elms: 12,
      type: Charts::ChartCountGenerator::BAR,
      range_type: Charts::ChartCountGenerator::MONTH,
      rgb: Charts::ChartCountGenerator::COMIC
    )

    issues_imported = build_stats_hash(
      title: "Issues imported",
      resource: Issue,
      num_of_elms: 12,
      type: Charts::ChartCountGenerator::BAR,
      range_type: Charts::ChartCountGenerator::MONTH,
      rgb: Charts::ChartCountGenerator::ISSUE
    )

    @charts = [
      site_visits,
      accounts_created,
      comics_imported,
      issues_imported
    ]
  end

  private

  def build_stats_hash(title:, resource:, num_of_elms:, type:, range_type:, rgb:)
    {
      title:,
      stats: stat(resource:, num_of_elms:, type:, range_type:, rgb:, label: title)
    }
  end

  def stat(resource:, num_of_elms:, type:, range_type:, rgb:, label:)
    Charts::CreatedAtCountChart.new(
      resource:,
      num_of_elms:,
      type:,
      range_type:,
      rgb:,
      label:
    ).generate
  end
end
