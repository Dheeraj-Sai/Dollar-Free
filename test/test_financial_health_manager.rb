# frozen_string_literal: true

require_relative "test_helper"

class FinancialHealthManagerTest < Minitest::Test
  def setup
    @expense_store = Tempfile.new(["expenses", ".json"])
    @goal_store = Tempfile.new(["savings_goals", ".json"])
    @budget_store = Tempfile.new(["budget", ".json"])
    @expense_manager = ExpenseManager.new(store_path: @expense_store.path)
    @savings_goal_manager = SavingsGoalManager.new(store_path: @goal_store.path)
    @manager = FinancialHealthManager.new(
      expense_manager: @expense_manager,
      savings_goal_manager: @savings_goal_manager,
      store_path: @budget_store.path
    )
  end

  def teardown
    @expense_store.close!
    @goal_store.close!
    @budget_store.close!
  end

  def test_sets_and_reloads_budget
    @manager.update_budget("500")

    assert_equal BigDecimal("500"), @manager.budget

    reloaded = FinancialHealthManager.new(
      expense_manager: @expense_manager,
      store_path: @budget_store.path
    )
    assert_equal BigDecimal("500"), reloaded.budget
  end

  def test_rejects_invalid_budget_amounts
    blank_error = assert_raises(ArgumentError) { @manager.update_budget(" ") }
    text_error = assert_raises(ArgumentError) { @manager.update_budget("five hundred") }
    zero_error = assert_raises(ArgumentError) { @manager.update_budget("0") }
    negative_error = assert_raises(ArgumentError) { @manager.update_budget("-50") }

    assert_equal "Budget amount is required.", blank_error.message
    assert_equal "Budget amount must be a valid number.", text_error.message
    assert_equal "Budget amount must be greater than zero.", zero_error.message
    assert_equal "Budget amount must be greater than zero.", negative_error.message
  end

  def test_creates_financial_health_instance
    assert_nil @manager.financial_health

    @manager.update_budget("300")
    health = @manager.financial_health

    refute_nil health
    assert_equal BigDecimal("300"), health.budget
  end

  def test_displays_comprehensive_report_for_healthy_budget
    @manager.update_budget("200")
    output = StringIO.new
    @manager.display_report(output: output)
    assert_includes output.string, "Top Expense: None recorded yet."

    @expense_manager.add_expense(category: "Food", amount: "5")
    output = StringIO.new
    @manager.display_report(output: output)
    assert_includes output.string, "Student Financial Health Report"
    assert_includes output.string, "Score Breakdown:"
    assert_includes output.string, "Budget Control:"
    assert_includes output.string, "Burn Rate & Pace:"
    assert_includes output.string, "Category Balance:"
    assert_includes output.string, "Savings Momentum:"
    assert_includes output.string, "Runway:"
    assert_includes output.string, "Top Expense: Food"
  end

  def test_displays_report_when_over_budget
    @manager.update_budget("200")
    @expense_manager.add_expense(category: "Other", amount: "250")
    output = StringIO.new
    @manager.display_report(output: output)
    assert_includes output.string, "Runway: Exhausted!"
    assert_includes output.string, "Critical (Needs Attention)"
    assert_includes output.string, "Alert! Budget exceeded."
  end

  def test_prompt_for_budget_and_direct_prompt_when_budget_nil
    output = StringIO.new
    @manager.display_report(input: StringIO.new("400\n"), output: output)
    assert_includes output.string, "No budget has been set yet."
    assert_equal BigDecimal("400"), @manager.budget

    invalid_output = StringIO.new
    assert_nil @manager.prompt_for_budget(input: StringIO.new("bad\n"), output: invalid_output)
    assert_includes invalid_output.string, "Unable to set budget: Budget amount must be a valid number."
  end

  def test_financial_health_menu_navigation
    output = StringIO.new
    @manager.financial_health_menu(input: StringIO.new("2\n500\n1\n3\n"), output: output)
    assert_includes output.string, "Budget updated to $500.00 successfully!"
    assert_includes output.string, "Student Financial Health Report"

    invalid_output = StringIO.new
    @manager.financial_health_menu(input: StringIO.new("9\n\n"), output: invalid_output)
    assert_includes invalid_output.string, "Invalid option. Please enter 1, 2, or 3."
  end

  def test_loads_empty_store_file_as_nil_budget
    File.write(@budget_store.path, "   \n")
    manager = FinancialHealthManager.new(
      expense_manager: @expense_manager,
      store_path: @budget_store.path
    )

    assert_nil manager.budget
    assert_nil manager.financial_health
  end
end
