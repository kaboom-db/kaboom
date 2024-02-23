module ApplicationHelper
  def strip_description(description:)
    return "" unless description.present?

    description.gsub(/<[^>]*>/, "")
  end

  def safe_description(description:)
    return "" unless description.present?

    description.gsub(/<\/?(a|script|figure|img|style|iframe)[^>]*>/, "").html_safe
  end

  def format_price(issue:)
    return issue.cover_price unless issue.currency.present?

    currency = issue.currency
    if currency.placement == Currency::VALUE_END
      "#{issue.cover_price}#{currency.symbol_native}"
    else
      "#{currency.symbol_native}#{issue.cover_price}"
    end
  end

  def should_show_sidebar?
    supported_controllers = [
      "dashboard",
      "comics"
    ]
    supported_controllers.include?(controller_name) && action_name == "index"
  end
end
