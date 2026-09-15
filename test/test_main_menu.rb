# frozen_string_literal: true

require_relative "test_helper"

class MainMenuTest < Minitest::Test
  class ExpenseManagerSpy
    attr_reader :input, :output

    def prompt_for_expense(input:, output:)
      @input = input
      @output = output
    end
  end

  def setup
    @input = StringIO.new
    @output = StringIO.new
    @expense_manager = ExpenseManagerSpy.new
    @menu = MainMenu.new(input: @input, output: @output, expense_manager: @expense_manager)
  end

  def test_displays_all_menu_options
    @menu.display_menu

    expected_options = ["Add Expense", "View Expenses", "Daily Report", "Financial Health",
                        "Spending Graph", "Savings Goal", "Achievements", "Exit"]
    expected_options.each { |option| assert_includes @output.string, option }
    assert_includes @output.string, "====== Dollar Free ======"
    assert_includes @output.string, "Choose an option:"
  end

  def test_option_one_opens_expense_functionality
    assert @menu.process_selection("1")
    assert_same @input, @expense_manager.input
    assert_same @output, @expense_manager.output
  end

  def test_option_two_shows_view_expenses_message
    assert @menu.process_selection("2")
    assert_includes @output.string, "View Expenses is not available yet."
  end

  def test_option_three_shows_daily_report_message
    assert @menu.process_selection("3")
    assert_includes @output.string, "Daily Report is not available yet."
  end

  def test_option_four_shows_financial_health_message
    assert @menu.process_selection("4")
    assert_includes @output.string, "Financial Health is not available yet."
  end

  def test_option_five_shows_spending_graph_message
    assert @menu.process_selection("5")
    assert_includes @output.string, "Spending Graph is not available yet."
  end

  def test_option_six_shows_savings_goal_message
    assert @menu.process_selection("6")
    assert_includes @output.string, "Savings Goal is not available yet."
  end

  def test_option_seven_shows_achievements_message
    assert @menu.process_selection("7")
    assert_includes @output.string, "Achievements is not available yet."
  end

  def test_option_eight_exits
    refute @menu.process_selection("8")
    assert_includes @output.string, "Goodbye!"
  end

  def test_blank_input_exits
    refute @menu.process_selection(nil)
    assert_includes @output.string, "Goodbye!"
  end

  def test_rejects_an_invalid_option
    assert @menu.process_selection("9")
    assert_includes @output.string, "Invalid option. Please enter a number from 1 to 8."
  end
end
