class ComicsController < ApplicationController
  before_action :set_comic, only: %i[show]

  # TODO: Add some specs for searching
  def index
    @header = "📚 Comics"
    if params[:search]
      @search = params[:search]
      # TODO: Better search algorithm
      @search_results = Comic.where("lower(name) LIKE ?", "%#{@search.downcase}%").or(Comic.where("lower(aliases) LIKE ?", "%#{@search.downcase}%"))
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
