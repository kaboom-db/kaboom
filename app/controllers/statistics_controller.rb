class StatisticsController < ApplicationController
  before_action :set_user
  before_action :set_year, only: [:show]

  def index
    set_metadata(title: "#{@user}'s Statistics", description: "Check out #{@user}'s statistics for comics and issues on Kaboom!")

    set_counts(year: Statistics::BaseCount::ALLTIME)
  end

  def show
    set_metadata(title: "#{@user}'s #{@year} Statistics", description: "Check out #{@user}'s #{@year} statistics for comics and issues on Kaboom!")

    set_counts
  end

  private

  def set_counts(year: nil)
    y = year || @year
    @read_counts, @collected_counts = Statistics::BaseCount.all_counts_for(year: y, user: @user)

    start_time = (y == Statistics::BaseCount::ALLTIME) ? Time.current : Time.new(y).end_of_year
    @read_collect_chart_data = Charts::UserCountsChart.new(
      resource: @user,
      num_of_elms: 12,
      type: Charts::ChartCountGenerator::BAR,
      range_type: Charts::ChartCountGenerator::MONTH,
      start_time:
    ).generate
  end

  def set_user
    @user = User.where.not(confirmed_at: nil).find_by!(username: params[:user_id])
  end

  def set_year
    @year = params[:id]
    head :not_found unless @year == Statistics::BaseCount::ALLTIME || Date.new(@year.to_i).gregorian?
  end
end
