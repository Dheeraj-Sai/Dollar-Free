require "bigdecimal"

# Shared formatting and validation for money amounts, used by the
# managers and FinancialHealth so it is not duplicated in each one.
module MoneyHelpers
  def format_amount(amount)
    format("$%.2f", amount)
  end

  def format_percentage(percentage)
    format("%.2f%%", percentage)
  end

  def parse_positive_amount(value, label)
    text = value.to_s.strip
    raise ArgumentError, "#{label} is required." if text.empty?

    begin
      parsed = BigDecimal(text)
    rescue ArgumentError
      raise ArgumentError, "#{label} must be a valid number."
    end

    raise ArgumentError, "#{label} must be greater than zero." unless parsed.positive?

    parsed
  end
end
