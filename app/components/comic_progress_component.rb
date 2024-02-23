# frozen_string_literal: true

class ComicProgressComponent < ViewComponent::Base
  def initialize(comic:, current_user:)
    @comic = comic
    @current_user = current_user
    @progress = current_user.progress_for(comic)
  end
end
