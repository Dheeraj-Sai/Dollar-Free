require "bigdecimal"

# Calculates financial health pillars, scores, runway, and insights.
class FinancialHealth
  DISCRETIONARY_CATEGORIES = %w[Entertainment Other].freeze

  attr_reader :budget, :expenses, :goals

  def initialize(budget:, expenses:, goals: [])
    @budget = budget
    @expenses = expenses
    @goals = goals
  end

  def total_expenses
    total = BigDecimal("0")
    expenses.each { |expense| total += expense.amount }
    total
  end

  def remaining_budget
    budget - total_expenses
  end

  def spent_percentage
    (total_expenses / budget * 100).round(2)
  end

  def budget_score
    return 35 if total_expenses.zero?
    return 0 if total_expenses >= budget

    ((1 - (total_expenses / budget)) * 35).round
  end

  def safe_daily_allowance
    (budget / 30).round(2, BigDecimal::ROUND_CEILING)
  end

  def daily_pace
    return BigDecimal("0") if total_expenses.zero?

    dates = expenses.map(&:date).uniq
    active_days = [dates.length, 1].max
    (total_expenses / active_days).round(2)
  end

  def pace_score
    return 30 if total_expenses.zero?
    return 0 if daily_pace >= (safe_daily_allowance * 2)
    return 30 if daily_pace <= safe_daily_allowance

    excess_ratio = (daily_pace - safe_daily_allowance) / safe_daily_allowance
    [30 - (excess_ratio * 30), 0].max.round
  end

  def runway_days
    return 0 if remaining_budget <= 0
    return 30 if daily_pace.zero?

    (remaining_budget / daily_pace).to_i
  end

  def wants_spent
    wants = BigDecimal("0")
    expenses.each do |expense|
      wants += expense.amount if DISCRETIONARY_CATEGORIES.include?(expense.category)
    end
    wants
  end

  def discretionary_percentage
    return BigDecimal("0") if total_expenses.zero?

    (wants_spent / total_expenses * 100).round(2)
  end

  def category_score
    return 20 if total_expenses.zero?
    return 20 if discretionary_percentage <= 30

    penalty = ((discretionary_percentage - 30) / 70 * 20)
    [20 - penalty, 0].max.round
  end

  def savings_score
    return 0 if goals.empty?

    avg_progress = goals.sum(&:progress_percentage) / goals.length
    (5 + (10 * avg_progress / 100)).round
  end

  def health_score
    return 0 if total_expenses > budget

    budget_score + pace_score + category_score + savings_score
  end

  def top_category
    return nil if expenses.empty?

    totals = Hash.new(BigDecimal("0"))
    expenses.each { |e| totals[e.category] += e.amount }
    cat, amount = totals.max_by { |_k, v| v }
    [cat, amount, (amount / total_expenses * 100).round(2)]
  end

  def status_label
    score = health_score
    if score >= 80
      "Healthy (Excellent)"
    elsif score >= 60
      "Moderate (Fair)"
    elsif score >= 40
      "Caution (At Risk)"
    else
      "Critical (Needs Attention)"
    end
  end

  def actionable_advice
    if total_expenses > budget
      "Alert! Budget exceeded. Freeze discretionary spending immediately to recover."
    elsif daily_pace > safe_daily_allowance
      "Slow down! Aim to keep daily spending below #{format_amount(safe_daily_allowance)}."
    elsif discretionary_percentage > 30
      "High discretionary spending. Look for areas in Entertainment/Other to cut back."
    else
      "Great job! Your spending pace and category balance are in good shape."
    end
  end

  private

  def format_amount(amount)
    format("$%.2f", amount)
  end
end
