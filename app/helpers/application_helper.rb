module ApplicationHelper
  # TODO: Add spec
  def strip_description(description:)
    return "" unless description.present?

    description.gsub(/<[^>]*>/, "")
  end

  def safe_description(description:)
    return "" unless description.present?

    description.gsub(/<\/?(a|script|figure|img|style)[^>]*>/, "").html_safe
  end
end
