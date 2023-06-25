class IssuesController < ApplicationController
  before_action :set_comic
  before_action :set_issue, only: %i[show]

  def index
  end

  def show
  end

  private

  def set_comic
    @comic = Comic.find(params[:comic_id])
  end

  def set_issue
    @issue = @comic.issues.find(params[:id])
  end
end
