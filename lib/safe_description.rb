class SafeDescription
  attr_accessor :description

  SAFE_REGEX = /<\/?(a|script|figure|img|style)[^>]*>/

  def initialize(description:)
    @description = description
  end

  def strip
    return "" unless description.present?

    description.gsub(SAFE_REGEX, "").html_safe
  end
end
