module ApplicationHelper
  SIDEBAR_CONTROLLERS = [
    "dashboard",
    "comics"
  ]

  def strip_description(description:)
    return "" unless description.present?

    description.gsub(/<[^>]*>/, "")
  end

  def safe_description(description:)
    return "" unless description.present?

    description.gsub(/<\/?(a|script|figure|img|style|iframe)[^>]*>/, "").html_safe
  end

  # TODO: Rewrite this to take in a user and collected issue once user has a currency and collected issue has a price paid.
  # def format_price(user:, collected_issue:)
  #   return collected_issue.price_paid unless user.currency.present?

  #   currency = user.currency
  #   if currency.placement == Currency::VALUE_END
  #     "#{collected_issue.price_paid}#{currency.symbol_native}"
  #   else
  #     "#{currency.symbol_native}#{collected_issue.price_paid}"
  #   end
  # end

  def should_show_sidebar?
    SIDEBAR_CONTROLLERS.include?(controller_name) && action_name == "index"
  end
end
