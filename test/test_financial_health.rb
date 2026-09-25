# frozen_string_literal: true

require_relative "test_helper"
require_relative "../lib/financial_health"
require_relative "../lib/expense"
require_relative "../lib/savings_goal"

class FinancialHealthTest < Minitest::Test
  def test_scores_budget_control_pillar
    health = FinancialHealth.new(budget: BigDecimal("300"), expenses: [])
    assert_equal 35, health.budget_score
    assert_equal BigDecimal("0.0"), health.spent_percentage

    expenses = [Expense.new(category: "Food", amount: BigDecimal("150"))]
    health = FinancialHealth.new(budget: BigDecimal("300"), expenses: expenses)
    assert_equal 18, health.budget_score
    assert_equal BigDecimal("50.0"), health.spent_percentage

    expenses = [Expense.new(category: "Food", amount: BigDecimal("300"))]
    health = FinancialHealth.new(budget: BigDecimal("300"), expenses: expenses)
    assert_equal 0, health.budget_score
  end

  def test_scores_safe_daily_and_runway
    health = FinancialHealth.new(budget: BigDecimal("300"), expenses: [])
    assert_equal BigDecimal("10.00"), health.safe_daily_allowance
    assert_equal 30, health.runway_days

    today = Date.today
    expenses = [Expense.new(category: "Food", amount: BigDecimal("10"), date: today)]
    health = FinancialHealth.new(budget: BigDecimal("300"), expenses: expenses)
    assert_equal 29, health.runway_days
  end

  def test_scores_daily_pace
    today = Date.today
    expenses = [Expense.new(category: "Food", amount: BigDecimal("10"), date: today)]
    health = FinancialHealth.new(budget: BigDecimal("300"), expenses: expenses)
    assert_equal 30, health.pace_score

    expenses = [Expense.new(category: "Food", amount: BigDecimal("15"), date: today)]
    health = FinancialHealth.new(budget: BigDecimal("300"), expenses: expenses)
    assert_equal 15, health.pace_score

    expenses = [Expense.new(category: "Food", amount: BigDecimal("35"), date: today)]
    health = FinancialHealth.new(budget: BigDecimal("300"), expenses: expenses)
    assert_equal 0, health.pace_score
  end

  def test_scores_category_balance_and_top_category
    health = FinancialHealth.new(budget: BigDecimal("300"), expenses: [])
    assert_equal 20, health.category_score
    assert_nil health.top_category

    expenses = [
      Expense.new(category: "Food", amount: BigDecimal("80")),
      Expense.new(category: "Entertainment", amount: BigDecimal("20"))
    ]
    health = FinancialHealth.new(budget: BigDecimal("300"), expenses: expenses)
    assert_equal 20, health.category_score
    assert_equal "Food", health.top_category.first

    expenses.push(Expense.new(category: "Entertainment", amount: BigDecimal("100")))
    health = FinancialHealth.new(budget: BigDecimal("300"), expenses: expenses)
    assert_equal 11, health.category_score
  end

  def test_scores_savings_momentum
    health = FinancialHealth.new(budget: BigDecimal("200"), expenses: [])
    assert_equal 0, health.savings_score

    goal = SavingsGoal.new(target_amount: BigDecimal("100"), days: 10)
    health = FinancialHealth.new(budget: BigDecimal("200"), expenses: [], goals: [goal])
    assert_equal 5, health.savings_score

    goal.add_saved_amount(BigDecimal("50"))
    health = FinancialHealth.new(budget: BigDecimal("200"), expenses: [], goals: [goal])
    assert_equal 10, health.savings_score
  end

  def test_overall_health_score_for_healthy_and_moderate
    health = FinancialHealth.new(budget: BigDecimal("200"), expenses: [])
    assert_equal 85, health.health_score
    assert_equal "Healthy (Excellent)", health.status_label

    goal = SavingsGoal.new(target_amount: BigDecimal("100"), days: 10, saved_amount: BigDecimal("100"))
    moderate_expenses = [Expense.new(category: "Food", amount: BigDecimal("60"))]
    health = FinancialHealth.new(budget: BigDecimal("300"), expenses: moderate_expenses, goals: [goal])
    assert_equal "Moderate (Fair)", health.status_label
  end

  def test_overall_health_score_for_caution_and_over_budget
    expenses = [Expense.new(category: "Food", amount: BigDecimal("45"))]
    health = FinancialHealth.new(budget: BigDecimal("200"), expenses: expenses)
    assert_equal "Caution (At Risk)", health.status_label

    expenses = [Expense.new(category: "Food", amount: BigDecimal("250"))]
    health = FinancialHealth.new(budget: BigDecimal("200"), expenses: expenses)
    assert_equal 0, health.health_score
    assert_equal "Critical (Needs Attention)", health.status_label
    assert_equal 0, health.runway_days
  end

  def test_actionable_advice_for_over_budget_and_pacing
    expenses = [Expense.new(category: "Food", amount: BigDecimal("250"))]
    health = FinancialHealth.new(budget: BigDecimal("200"), expenses: expenses)
    assert_includes health.actionable_advice, "Alert! Budget exceeded."

    expenses = [Expense.new(category: "Food", amount: BigDecimal("30"))]
    health = FinancialHealth.new(budget: BigDecimal("200"), expenses: expenses)
    assert_includes health.actionable_advice, "Slow down!"
  end

  def test_actionable_advice_for_wants_and_healthy
    expenses = [
      Expense.new(category: "Food", amount: BigDecimal("3")),
      Expense.new(category: "Entertainment", amount: BigDecimal("3"))
    ]
    health = FinancialHealth.new(budget: BigDecimal("200"), expenses: expenses)
    assert_includes health.actionable_advice, "High discretionary spending."

    expenses = [Expense.new(category: "Food", amount: BigDecimal("5"))]
    health = FinancialHealth.new(budget: BigDecimal("200"), expenses: expenses)
    assert_includes health.actionable_advice, "Great job!"
  end
end
