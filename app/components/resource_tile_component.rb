# frozen_string_literal: true

class ResourceTileComponent < ViewComponent::Base
  def initialize(resource:, resource_path:, read: false, collected: false, wishlisted: false, favourited: false)
    @resource = resource
    @resource_path = resource_path
    @read = read
    @collected = collected
    @wishlisted = wishlisted
    @favourited = favourited
    @year = resource.respond_to?(:year) ? resource.year : nil
  end
end
