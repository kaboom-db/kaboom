# frozen_string_literal: true

class Actions::CollectActionComponent < ViewComponent::Base
  def initialize(resource:, user:)
    @resource = resource
    @user = user

    @has_collected = user.collection.include?(@resource)
  end

  def before_render
    @resource_path = @resource.instance_of?(Issue) ? comic_issue_path(@resource, comic_id: @resource.comic.id) : comic_path(@resource)
  end
end
