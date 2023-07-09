class PagesController < ApplicationController
  before_action :user_required, only: %i[dashboard]

  def index
    redirect_to dashboard_index_path if user_signed_in?
    return if performed?

    @header = "💥 KABOOM!"
    @comic_count = Comic.count
    @user_count = User.count
  end
end
