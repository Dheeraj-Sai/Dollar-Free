# frozen_string_literal: true

require_relative "test_helper"

class ExpenseManagerTest < Minitest::Test
  def setup
    @manager = ExpenseManager.new
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

  def test_reports_a_useful_error_for_invalid_prompt_input
    input = StringIO.new("Holiday\n10\n")
    output = StringIO.new

    result = @manager.prompt_for_expense(input: input, output: output)

    assert_nil result
    assert_includes output.string, "Unable to add expense: Invalid expense category 'Holiday'"
  end
end
