# frozen_string_literal: true

class FullWidthComponent < ViewComponent::Base
  def initialize(extra_classes: [], data: {})
    @extra_classes = extra_classes
    @data = data
  end
end
