module Pages
  class ResourceMetadata < Metadata
    include ApplicationHelper

    attr_reader :resource

    def initialize(resource:)
      @resource = resource
    end

    def title = resource.name

    def description = strip_description(description: resource.description)

    def image = resource.image
  end
end
