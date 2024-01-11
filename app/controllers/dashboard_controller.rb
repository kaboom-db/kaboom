class DashboardController < ApplicationController
  before_action :user_required

  def index
    @header = "Dashboard"

    @issue_history = current_user.read_issues.order(read_at: :desc).limit(6)
    @issues_read = current_user.read_issues.count
    @issues_collected = current_user.collection.count

    @deck = current_user.incompleted_comics.take(6)

    @chart_data = Charts::DayCountGenerator.new(user: current_user, num_of_days: 30, type: Charts::DayCountGenerator::LINE).generate
  end

  def history
    @issue_history = current_user.read_issues
      .order(read_at: :desc)
      .where(build_filters)
      .page(params[:page])
      .per(30)

    @issue_history_grouped = @issue_history.group_by { _1.read_at.strftime("%-d %b %Y") }
  end

  def collection
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
