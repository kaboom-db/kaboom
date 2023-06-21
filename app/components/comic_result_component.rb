# frozen_string_literal: true

class ComicResultComponent < ViewComponent::Base
  def initialize(resource:)
    @resource = resource
  end
end
