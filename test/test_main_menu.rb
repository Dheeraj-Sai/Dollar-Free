# frozen_string_literal: true

require_relative "test_helper"

class MainMenuTest < Minitest::Test
  class ExpenseManagerSpy
    attr_reader :input, :output, :display_output, :report_output, :graph_input, :graph_output

    def prompt_for_expense(input:, output:)
      @input = input
      @output = output
    end

    def display_expenses(output:)
      @display_output = output
    end

    def generate_daily_report(output:)
      @report_output = output
    end

    def prompt_for_spending_graph(input:, output:)
      @graph_input = input
      @graph_output = output
    end
  end

  class SavingsGoalManagerSpy
    attr_reader :input, :output

    def savings_goal_menu(input:, output:)
      @input = input
      @output = output
    end
  end

  class FinancialHealthManagerSpy
    attr_reader :input, :output

    def financial_health_menu(input:, output:)
      @input = input
      @output = output
    end
  end

  def setup
    @input = StringIO.new
    @output = StringIO.new
    @expense_manager = ExpenseManagerSpy.new
    @savings_goal_manager = SavingsGoalManagerSpy.new
    @financial_health_manager = FinancialHealthManagerSpy.new
    @menu = MainMenu.new(
      input: @input,
      output: @output,
      expense_manager: @expense_manager,
      savings_goal_manager: @savings_goal_manager,
      financial_health_manager: @financial_health_manager
    )
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

  def test_option_two_opens_view_expenses
    assert @menu.process_selection("2")
    assert_same @output, @expense_manager.display_output
  end

  def test_option_three_opens_daily_report
    assert @menu.process_selection("3")
    assert_same @output, @expense_manager.report_output
  end

  def test_option_four_opens_financial_health_menu
    assert @menu.process_selection("4")
    assert_same @input, @financial_health_manager.input
    assert_same @output, @financial_health_manager.output
  end

  def test_option_five_opens_spending_graph
    assert @menu.process_selection("5")
    assert_same @input, @expense_manager.graph_input
    assert_same @output, @expense_manager.graph_output
  end

  def test_option_six_opens_savings_goal_menu
    assert @menu.process_selection("6")
    assert_same @input, @savings_goal_manager.input
    assert_same @output, @savings_goal_manager.output
  end

  def test_option_seven_shows_achievements_message
    assert @menu.process_selection("7")
    assert_includes @output.string, "Achievements is not available yet."
  end

  def test_option_eight_exits
    refute @menu.process_selection("8")
    assert_includes @output.string, "Expense Tracker Signing OFF!!!"
  end

  def test_blank_input_exits
    refute @menu.process_selection(nil)
    assert_includes @output.string, "Expense Tracker Signing OFF!!!"
  end

  def test_rejects_an_invalid_option
    assert @menu.process_selection("9")
    assert_includes @output.string, "Invalid option. Please enter a number from 1 to 8."
  end
end
