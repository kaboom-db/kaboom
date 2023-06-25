class IssuesController < ApplicationController
  before_action :set_comic
  before_action :set_issue, only: %i[show]

  def index
  end

  def show
    redirect_to comic_path(@comic), notice: "Could not find that issue." unless @issue.present?
  end

  private

  def set_comic
    @comic = Comic.find(params[:comic_id])
  end

  def set_issue
    @issue = @comic.issues.find_by(issue_number: params[:id].gsub("_", ".").to_f)
  end
end
