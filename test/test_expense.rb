# frozen_string_literal: true

require_relative "test_helper"

class ExpenseTest < Minitest::Test
  def test_stores_category_and_amount
    expense = Expense.new(category: "Food", amount: BigDecimal("15.50"))

    assert_equal "Food", expense.category
    assert_equal BigDecimal("15.50"), expense.amount
  end
end
