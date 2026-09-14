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

  {
    "2" => "View Expenses",
    "3" => "Daily Report",
    "4" => "Financial Health",
    "5" => "Spending Graph",
    "6" => "Savings Goal",
    "7" => "Achievements"
  }.each do |selection, section_name|
    define_method("test_option_#{selection}_opens_#{section_name.downcase.tr(' ', '_')}_section") do
      assert @menu.process_selection(selection)
      assert_includes @output.string, "#{section_name} is not available yet."
    end
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
