class StatisticsController < ApplicationController
  before_action :set_user
  before_action :set_year, only: [:show]
  before_action :check_private

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
      type: Charts::Constants::BAR,
      range_type: Charts::FrequencyChartGenerator::MONTH,
      start_time:
    ).generate

    range = (y == Statistics::BaseCount::ALLTIME) ? (..Time.current) : (Time.new(y).beginning_of_year..Time.new(y).end_of_year.end_of_day)
    @distinct_publisher_chart_data = Charts::DistinctPublishersCountChart.new(
      resource: @user,
      type: Charts::Constants::DOUGHNUT,
      range:
    ).generate

    @most_activity_counts = Statistics::UserMostActivityCount.new(year: y, user: @user)
  end

  def set_user
    @user = User.where.not(confirmed_at: nil).find_by!(username: params[:user_id])
  end

  def set_year
    @year = params[:id]
    head :not_found unless @year == Statistics::BaseCount::ALLTIME || Date.new(@year.to_i).gregorian?
  end

  def check_private
    render "users/private_user" if @user != current_user && @user.private?
  end
end
