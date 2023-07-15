# frozen_string_literal: true

class Actions::FavouriteActionComponent < ViewComponent::Base
  def initialize(resource:, user:)
    @resource = resource
    @user = user

    @is_favourited = resource.instance_of?(Issue) ?
      user.favourited_issues.include?(resource) :
      user.favourited_comics.include?(resource)
  end

  def before_render
    @resource_path = @resource.instance_of?(Issue) ? comic_issue_path(@resource, comic_id: @resource.comic.id) : comic_path(@resource)
  end
end
