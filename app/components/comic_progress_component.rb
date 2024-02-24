# frozen_string_literal: true

class ComicProgressComponent < ViewComponent::Base
  include Turbo::FramesHelper

  def initialize(comic:, current_user:)
    @comic = comic
    @current_user = current_user
    @progress = current_user.progress_for(comic)
  end
end
