class PagesController < ApplicationController
  before_action :user_required, only: %i[dashboard]

  PRIVACY_POLICY_UPDATE = Date.new(2024, 4, 6)

  def index
    redirect_to dashboard_path if user_signed_in?
    return if performed?

    set_metadata(title: "", description: "Track your comic reading habits. Discover new issues and add to your ever growing pull list!")

    @header = "💥 KABOOM!"
    @comic_count = Comic.count
    @user_count = User.count
  end

  def privacy
    set_metadata(title: "", description: "Track your comic reading habits. Discover new issues and add to your ever growing pull list!")
  end

  def sitemap
    @comics = Comic.includes(:issues).where(nsfw: false)
    @users = User.where.not(confirmed_at: nil).where(private: false)

    respond_to do |format|
      format.xml { render layout: false }
    end
  end
end
