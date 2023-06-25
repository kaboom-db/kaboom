# frozen_string_literal: true

class ResourcePosterComponent < ViewComponent::Base
  def initialize(resource:, resource_path:)
    @resource = resource
    @resource_path = resource_path
  end
end
