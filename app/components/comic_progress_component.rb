# frozen_string_literal: true

class ComicProgressComponent < ViewComponent::Base
  include Turbo::FramesHelper

  def initialize(comic:, current_user:)
    @comic = comic
    @current_user = current_user
    @latest_reread = comic.latest_reread_for(current_user)
    @progress = current_user.progress_for(comic, latest_reread: @latest_reread)
    @next_issue = current_user.next_up_for(comic, latest_reread: @latest_reread)
  end
end
