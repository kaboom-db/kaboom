class ApplicationController < ActionController::Base
  private

  def user_required
    return if user_signed_in?
    flash[:notice] = "You need to be logged in access this page."
    redirect_to new_session_path(User)
  end
end
