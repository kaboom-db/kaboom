class ApplicationController < ActionController::Base
  unless Rails.application.config.consider_all_requests_local
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActionController::RoutingError, with: :not_found
    rescue_from AbstractController::ActionNotFound, with: :not_found
  end

  private

  def not_found
    render "application/not_found", formats: [:html], status: 404
  end

  def user_required
    return if user_signed_in?
    flash[:notice] = "You need to be logged in to access this page."
    redirect_to new_session_path(User)
  end

  def set_resource_metadata(resource:)
    @metadata = Pages::ResourceMetadata.new(resource:)
  end

  def set_metadata(title:, description:)
    image = build_asset_url(name: "header.png")
    @metadata = Pages::BasicMetadata.new(title:, description:, image:)
  end

  def build_asset_url(name:)
    request.base_url + ActionController::Base.helpers.asset_path("header.png")
  end
end
