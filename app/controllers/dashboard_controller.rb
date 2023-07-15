class DashboardController < ApplicationController
  before_action :user_required

  def index
    @header = "Dashboard"

    @issue_history = current_user.read_issues.order(read_at: :desc).limit(6)
    @issues_read = current_user.read_issues.count

    @chart_data = Charts::DayCountGenerator.new(user: current_user, num_of_days: 15).generate
  end

  def history
    @header = "Your history"

    @issue_history = current_user.read_issues
      .order(read_at: :desc)
      .where(build_filters)
      .page(params[:page])
      .per(30)

    @issue_history_grouped = @issue_history.group_by { |h| h.read_at.strftime("%e %b %Y") }
  end

  private

  def build_filters
    filters = {}
    filters[:issue] = params[:issue] if params[:issue].present?
    filters
  end
end
