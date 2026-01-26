module ApplicationHelper

  def page_title(title = nil)
    if title.present?
      content_for(:title) { title }
    end
  end

  def format_number(number)
    return nil unless number
    number_with_delimiter(number)
  end

  def format_currency_value(amount, currency = "USD")
    return "TBA" unless amount

    unit = case currency
           when "EUR" then "€"
           when "GBP" then "£"
           else "$"
           end

    number_to_currency(amount, precision: 0, unit: unit)
  end
end
