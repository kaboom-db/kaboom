class ComicsController < ApplicationController
  include VisitConcerns

  before_action :set_comic, only: %i[show]
  before_action :user_required, only: %i[import]

  def index
    @header = "📚 Comics"
    if params[:search]
      @search = params[:search]
      @search_results = Comic.search(query: @search)
    end
    @recently_updated = Comic.order(updated_at: :desc).limit(6)
    @trending = Comic.trending
    @recently_updated_issues = Issue.order(updated_at: :desc).limit(6)
    @trending_issues = Issue.trending
  end

  def show
    add_visit(user: current_user, visited: @comic)
  end

  def import
    @comic = Comic.import(comic_vine_id: params[:comicvine_id])
    unless @comic.persisted?
      return redirect_to comics_path, alert: "There was an error importing this comic."
    end

    @comic.import_issues

    redirect_to comic_path(@comic), notice: "#{@comic.name} was successfully imported."
  end

  private

  def set_comic
    @comic = Comic.find(params[:id])
  end
end
