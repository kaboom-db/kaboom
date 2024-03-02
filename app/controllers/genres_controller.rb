class GenresController < ApplicationController
  before_action :set_genre
  before_action :genre_required

  def show
    set_metadata(title: "#{@genre.name} Comics", description: "Check out the #{genre.name} comics available on Kaboom.")

    @trending_comics = Comic.trending_for(@genre).limit(5)
    @comics = @genre.comics.safe_for_work.order(name: :asc).paginate(page: params[:page], per_page: 30)
  end

  private

  def set_genre
    @genre = Genre.where("LOWER(name) = ?", params[:id]).first
  end

  def genre_required
    not_found unless @genre.present?
  end
end
