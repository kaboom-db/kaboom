class DashboardController < ApplicationController
  before_action :user_required

  def index
    @header = "Dashboard"

    @issue_history = current_user.read_issues.order(read_at: :desc).limit(6)
  end

  def history
    @header = "Your history"

    @issue_history = current_user.read_issues
      .order(read_at: :desc)
      .where(build_filters)
      .group_by { |h| h.read_at.strftime("%e %b %Y") }
  end

  private

  def build_filters
    filters = {}
    filters[:issue] = params[:issue] if params[:issue].present?
    filters
  end
end
