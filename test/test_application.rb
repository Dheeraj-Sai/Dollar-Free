# frozen_string_literal: true

require_relative "test_helper"

class ApplicationTest < Minitest::Test
  # A temporary store keeps these tests from writing to the real
  # data/expenses.json file.
  def setup
    @store = Tempfile.new(["expenses", ".json"])
    @goal_store = Tempfile.new(["savings_goals", ".json"])
    @budget_store = Tempfile.new(["budget", ".json"])
  end

  def teardown
    @store.close!
    @goal_store.close!
    @budget_store.close!
  end

  def new_menu(input:, output:)
    expense_manager = ExpenseManager.new(store_path: @store.path)
    savings_goal_manager = SavingsGoalManager.new(store_path: @goal_store.path)
    MainMenu.new(
      input: input,
      output: output,
      expense_manager: expense_manager,
      savings_goal_manager: savings_goal_manager,
      financial_health_manager: FinancialHealthManager.new(
        expense_manager: expense_manager,
        savings_goal_manager: savings_goal_manager,
        store_path: @budget_store.path
      )
    )
  end

  def test_user_can_add_an_expense_from_the_main_menu
    input = StringIO.new("1\nFood\n15.50\n8\n")
    output = StringIO.new

    new_menu(input: input, output: output).run

    assert_includes output.string, "====== Dollar Free ======"
    assert_includes output.string, "Add Expense"
    assert_includes output.string, "Expense added successfully!"
    assert_includes output.string, "Expense Tracker Signing OFF!!!"
  end

  def test_user_sees_an_error_for_an_invalid_menu_choice
    input = StringIO.new("9\n8\n")
    output = StringIO.new

    new_menu(input: input, output: output).run

    assert_includes output.string, "Invalid option. Please enter a number from 1 to 8."
    assert_includes output.string, "Expense Tracker Signing OFF!!!"
  end

  def test_user_can_view_the_spending_graph_from_the_main_menu
    today = Date.today.strftime("%m/%d/%Y")
    input = StringIO.new("1\nFood\n15.50\n5\n#{today}\n8\n")
    output = StringIO.new

    new_menu(input: input, output: output).run

    assert_includes output.string, "Spending Graph"
    assert_includes output.string, "Food"
    assert_includes output.string, "Expense Tracker Signing OFF!!!"
  end

  def test_user_can_add_and_view_multiple_savings_goals_from_the_main_menu
    input = StringIO.new("6\n1\n300\n30\n1\n100\n3\n2\n4\n8\n")
    output = StringIO.new

    new_menu(input: input, output: output).run

    assert_includes output.string, "Savings goal added successfully!"
    assert_includes output.string, "You need to save $10.00 per day."
    assert_includes output.string, "1. Target: $300.00 | Time: 30 days | Daily: $10.00"
    assert_includes output.string, "2. Target: $100.00 | Time: 3 days | Daily: $33.34"
  end

  def test_user_can_add_savings_progress_from_the_main_menu
    input = StringIO.new("6\n1\n100\n10\n3\n1\n25\n2\n4\n8\n")
    output = StringIO.new

    new_menu(input: input, output: output).run

    assert_includes output.string, "Progress added successfully!"
    assert_includes output.string, "This goal is now 25.00% complete."
    assert_includes output.string, "Saved: $25.00 | Remaining: $75.00 | Progress: 25.00%"
  end

  def test_user_can_set_budget_and_view_financial_health_from_the_main_menu
    input = StringIO.new("1\nFood\n40.00\n4\n2\n100\n1\n3\n8\n")
    output = StringIO.new

    new_menu(input: input, output: output).run

    assert_includes output.string, "Budget updated to $100.00 successfully!"
    assert_includes output.string, "Student Financial Health Report"
    assert_includes output.string, "Budget: $100.00"
    assert_includes output.string, "Total Spent: $40.00"
    assert_includes output.string, "Remaining: $60.00 (60.00% remaining)"
    assert_includes output.string, "Score Breakdown:"
    assert_includes output.string, "Budget Control:"
    assert_includes output.string, "Burn Rate & Pace:"
    assert_includes output.string, "Category Balance:"
    assert_includes output.string, "Runway:"
  end
end
