class CollectedIssuesController < ApplicationController
  before_action :user_required
  before_action :set_collected_issue

  def update
    @collected_issue.update(collected_issue_params)
    redirect_back fallback_location: dashboard_collection_path
  end

  private

  def collected_issue_params
    params.require(:collected_issue).permit(:price_paid, :collected_on)
  end

  def set_collected_issue
    @collected_issue = current_user.collected_issues.find(params[:id])
  end
end
