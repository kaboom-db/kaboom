module ApplicationHelper
  def safe_description(description:)
    return "" unless description.present?

    description.gsub(/<\/?(a|script|figure|img|style)[^>]*>/, "").html_safe
  end
end
