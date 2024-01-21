class PagesController < ApplicationController
  before_action :user_required, only: %i[dashboard]

  def index
    redirect_to dashboard_path if user_signed_in?
    return if performed?

    set_metadata(title: "", description: "Track your comic reading habits. Discover new issues and add to your ever growing pull list!")

    @header = "💥 KABOOM!"
    @comic_count = Comic.count
    @user_count = User.count
  end
end
