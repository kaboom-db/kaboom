class SearchController < ApplicationController
  def index
    set_metadata(title: "Global Search", description: "Search for comics and users on Kaboom!")

    if params[:search]
      @search = params[:search]
      @comics = Comic.search(query: @search, nsfw: current_user&.show_nsfw?)
      @users = User.search(query: @search)
    end
  end
end
