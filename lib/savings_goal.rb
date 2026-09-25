require "bigdecimal"

# Stores one savings target and the amount needed each day to reach it.
class SavingsGoal
  attr_reader :target_amount, :days, :daily_amount, :saved_amount

  def initialize(target_amount:, days:, saved_amount: BigDecimal("0"))
    @target_amount = target_amount
    @days = days
    @saved_amount = saved_amount
    @daily_amount = (target_amount / days).round(2, BigDecimal::ROUND_CEILING)
  end

  def add_saved_amount(amount)
    @saved_amount += amount
  end

  def remaining_amount
    [target_amount - saved_amount, BigDecimal("0")].max
  end

  def progress_percentage
    [(saved_amount / target_amount * 100), BigDecimal("100")].min.round(2)
  end

  def to_h
    {
      "target_amount" => target_amount.to_s("F"),
      "days" => days,
      "saved_amount" => saved_amount.to_s("F")
    }
  end

  def self.from_h(attributes)
    new(
      target_amount: BigDecimal(attributes["target_amount"].to_s),
      days: attributes["days"].to_i,
      saved_amount: BigDecimal(attributes.fetch("saved_amount", "0").to_s)
    )
  end
end
