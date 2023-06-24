class ComicsController < ApplicationController
  before_action :set_comic, only: %i[show]

  def index
    @header = "📚 Comics"
    if params[:search]
      @search = params[:search]
      @search_results = Comic.search(query: @search)
    end
    @comics = Comic.all
  end

  def show
  end

  private

  def set_comic
    @comic = Comic.find(params[:id])
  end
end
