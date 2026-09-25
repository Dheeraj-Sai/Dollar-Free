# frozen_string_literal: true

require_relative "test_helper"

class ExpenseManagerTest < Minitest::Test
  def setup
    @store = Tempfile.new(["expenses", ".json"])
    @manager = ExpenseManager.new(store_path: @store.path)
  end

  def teardown
    @store.close!
  end

  def test_creates_and_stores_a_valid_expense
    expense = @manager.add_expense(category: "Food", amount: "15.50")

    assert_equal expense, @manager.expenses.first
    assert_equal 1, @manager.expenses.length
  end

  def test_stores_the_entered_category_and_amount
    expense = @manager.add_expense(category: "food", amount: "15.50")

    assert_equal "Food", expense.category
    assert_equal BigDecimal("15.50"), expense.amount
  end

  def test_rejects_a_negative_amount
    error = assert_raises(ArgumentError) { @manager.add_expense(category: "Food", amount: "-4.25") }

    assert_equal "Expense amount must be greater than zero.", error.message
  end

  def test_rejects_a_zero_amount
    error = assert_raises(ArgumentError) { @manager.add_expense(category: "Food", amount: "0") }

    assert_equal "Expense amount must be greater than zero.", error.message
  end

  def test_rejects_a_non_numeric_amount
    error = assert_raises(ArgumentError) { @manager.add_expense(category: "Food", amount: "fifteen") }

    assert_equal "Expense amount must be a valid number.", error.message
  end

  def test_rejects_an_invalid_category
    error = assert_raises(ArgumentError) { @manager.add_expense(category: "Holiday", amount: "10") }

    assert_includes error.message, "Invalid expense category 'Holiday'"
  end

  def test_rejects_a_blank_category
    error = assert_raises(ArgumentError) { @manager.add_expense(category: "  ", amount: "10") }

    assert_equal "Expense category is required.", error.message
  end

  def test_prompts_for_and_creates_an_expense
    input = StringIO.new("Food\n15.50\n")
    output = StringIO.new

    expense = @manager.prompt_for_expense(input: input, output: output)

    assert_equal BigDecimal("15.50"), expense.amount
    assert_includes output.string, "Expense added successfully!"
  end

  def test_displays_a_message_when_there_are_no_expenses
    output = StringIO.new

    @manager.display_expenses(output: output)

    assert_includes output.string, "No expenses recorded to be shown."
  end

  def test_displays_each_stored_expense
    @manager.add_expense(category: "Food", amount: "15.50")
    @manager.add_expense(category: "Transport", amount: "42.75")
    output = StringIO.new

    @manager.display_expenses(output: output)

    assert_includes output.string, "1. #{Date.today} - Food - 15.5"
    assert_includes output.string, "2. #{Date.today} - Transport - 42.75"
  end

  def test_stored_expenses_are_reloaded_from_the_store
    @manager.add_expense(category: "Food", amount: "15.50")

    reloaded = ExpenseManager.new(store_path: @store.path)

    assert_equal 1, reloaded.expenses.length
    assert_equal "Food", reloaded.expenses.first.category
    assert_equal BigDecimal("15.50"), reloaded.expenses.first.amount
    assert_equal Date.today, reloaded.expenses.first.date
  end

  def test_daily_report_shows_only_todays_expenses_and_the_total
    @manager.add_expense(category: "Food", amount: "15.50")
    @manager.add_expense(category: "Transport", amount: "4.50")
    @manager.expenses.push(Expense.new(category: "Housing", amount: BigDecimal("900"), date: Date.today - 1))
    output = StringIO.new

    @manager.generate_daily_report(output: output)

    assert_includes output.string, "Daily Report for #{Date.today}"
    assert_includes output.string, "1. Food - 15.5"
    assert_includes output.string, "2. Transport - 4.5"
    refute_includes output.string, "Housing"
    assert_includes output.string, "Total spent: 20.0"
  end

  def test_daily_report_when_nothing_was_spent_today
    output = StringIO.new

    @manager.generate_daily_report(output: output)

    assert_includes output.string, "No expenses recorded today."
  end

  def test_reports_a_useful_error_for_invalid_prompt_input
    input = StringIO.new("Holiday\n10\n")
    output = StringIO.new

    result = @manager.prompt_for_expense(input: input, output: output)

    assert_nil result
    assert_includes output.string, "Unable to add expense: Invalid expense category 'Holiday'"
  end

  def test_spending_graph_shows_a_bar_for_each_category_with_spending
    @manager.add_expense(category: "Food", amount: "50")
    @manager.add_expense(category: "Food", amount: "20")
    @manager.add_expense(category: "Transport", amount: "120")
    output = StringIO.new

    @manager.generate_spending_graph(output: output)

    assert_includes output.string, "Spending Graph for #{Date.today}"
    assert_includes output.string, " 200 | "
    assert_includes output.string, "Food Transport"
  end

  def test_spending_graph_hides_categories_with_no_spending
    @manager.add_expense(category: "Food", amount: "50")
    output = StringIO.new

    @manager.generate_spending_graph(output: output)

    refute_includes output.string, "Transport"
  end

  def test_spending_graph_switches_to_the_higher_scale_when_a_category_exceeds_two_hundred
    @manager.add_expense(category: "Housing", amount: "250")
    output = StringIO.new

    @manager.generate_spending_graph(output: output)

    assert_includes output.string, "1000 | "
    assert_includes output.string, " 950 | "
  end

  def test_spending_graph_caps_a_bar_at_the_maximum
    @manager.add_expense(category: "Housing", amount: "1500")
    output = StringIO.new

    @manager.generate_spending_graph(output: output)

    lines = output.string.lines
    top_row = lines.find { |line| line.start_with?("1000 | ") }

    assert_includes top_row, "*"
  end

  def test_spending_graph_message_when_nothing_was_spent_today
    output = StringIO.new

    @manager.generate_spending_graph(output: output)

    assert_includes output.string, "No expenses recorded today."
  end

  def test_prompt_for_spending_graph_reads_a_mm_dd_yyyy_date
    @manager.expenses.push(Expense.new(category: "Food", amount: BigDecimal("50"), date: Date.new(2026, 1, 5)))
    input = StringIO.new("01/05/2026\n")
    output = StringIO.new

    @manager.prompt_for_spending_graph(input: input, output: output)

    assert_includes output.string, "Spending Graph for 2026-01-05"
    assert_includes output.string, "Food"
  end

  def test_prompt_for_spending_graph_rejects_an_invalid_date_format
    input = StringIO.new("2026-01-05\n")
    output = StringIO.new

    @manager.prompt_for_spending_graph(input: input, output: output)

    assert_includes output.string, "Unable to show spending graph: Date must be in mm/dd/yyyy format."
  end

  def test_prompt_for_spending_graph_rejects_a_blank_date
    input = StringIO.new("\n")
    output = StringIO.new

    @manager.prompt_for_spending_graph(input: input, output: output)

    assert_includes output.string, "Unable to show spending graph: Date is required."
  end
end
