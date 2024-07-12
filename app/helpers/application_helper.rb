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

  def format_price(user:, price:)
    return price unless user.currency.present?

    currency = user.currency
    padded_price = "%.2f" % price
    if currency.placement == Currency::VALUE_END
      "#{padded_price}#{currency.symbol_native}"
    else
      "#{currency.symbol_native}#{padded_price}"
    end
  end

  def should_show_sidebar?
    SIDEBAR_CONTROLLERS.include?(controller_name) && action_name == "index"
  end

  def display_if(condition, value)
    return value if condition
    "-"
  end
end
