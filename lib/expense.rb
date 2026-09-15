require "bigdecimal"
require "date"

class Expense
  attr_reader :category, :amount, :date

  def initialize(category:, amount:, date: Date.today)
    @category = category
    @amount = amount
    @date = date
  end

  def to_h
    {
      "category" => category,
      "amount" => amount.to_s("F"),
      "date" => date.to_s
    }
  end

  def self.from_h(attributes)
    new(
      category: attributes["category"].to_s,
      amount: BigDecimal(attributes["amount"].to_s),
      date: Date.parse(attributes["date"].to_s)
    )
  end
end
