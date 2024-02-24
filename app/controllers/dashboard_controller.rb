class DashboardController < ApplicationController
  before_action :user_required

  def index
    set_metadata(title: "Dashboard", description: "Track your comic reading habits. Discover new issues and add to your ever growing pull list!")

    @header = "Dashboard"

    @issue_history = current_user.read_issues.order(read_at: :desc).limit(6)
    @issues_read = current_user.read_issues.count
    @issues_collected = current_user.collection.count

    @deck = current_user.incompleted_comics.take(6)

    @chart_data = Charts::UserCountsChart.new(resource: current_user, num_of_elms: 14, type: Charts::ChartCountGenerator::LINE, range_type: Charts::FrequencyChartGenerator::DAY).generate
  end

  def history
    set_metadata(title: "Your History", description: "Track your comic reading habits. Discover new issues and add to your ever growing pull list!")

    @issue_history = current_user.read_issues
      .order(read_at: :desc)
      .where(build_filters)
      .page(params[:page])
      .per(30)

    @issue_history_grouped = @issue_history.group_by { _1.read_at.strftime("%-d %b %Y") }
  end

  def collection
    set_metadata(title: "Your Collection", description: "Track your comic reading habits. Discover new issues and add to your ever growing pull list!")

    @collection = current_user.collected_issues
      .order(collected_on: :desc)
      .page(params[:page])
      .per(30)

    @collection_grouped = @collection.group_by { _1.collected_on.strftime("%-d %b %Y") }
  end

  private

  def build_filters
    filters = {}
    filters[:issue] = params[:issue] if params[:issue].present?
    filters
  end
end
