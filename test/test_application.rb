# frozen_string_literal: true

require_relative "test_helper"

class ApplicationTest < Minitest::Test
  # A temporary store keeps these tests from writing to the real
  # data/expenses.json file.
  def setup
    @store = Tempfile.new(["expenses", ".json"])
  end

  def teardown
    @store.close!
  end

  def new_menu(input:, output:)
    MainMenu.new(
      input: input,
      output: output,
      expense_manager: ExpenseManager.new(store_path: @store.path)
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
end
