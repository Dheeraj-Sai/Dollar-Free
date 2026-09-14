# frozen_string_literal: true

require "bigdecimal"

# A single categorized expense. Amounts use BigDecimal so money is not stored
# as an imprecise floating-point value.
class Expense
  attr_reader :category, :amount

  def initialize(category:, amount:)
    @category = category
    @amount = amount
  end
end
