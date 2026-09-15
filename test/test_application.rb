# frozen_string_literal: true

require_relative "test_helper"

class ApplicationTest < Minitest::Test
  def test_user_can_add_an_expense_from_the_main_menu
    input = StringIO.new("1\nFood\n15.50\n8\n")
    output = StringIO.new

    MainMenu.new(input: input, output: output).run

    assert_includes output.string, "====== Dollar Free ======"
    assert_includes output.string, "Add Expense"
    assert_includes output.string, "Expense added successfully!"
    assert_includes output.string, "Goodbye!"
  end

  def test_user_sees_an_error_for_an_invalid_menu_choice
    input = StringIO.new("9\n8\n")
    output = StringIO.new

    MainMenu.new(input: input, output: output).run

    assert_includes output.string, "Invalid option. Please enter a number from 1 to 8."
    assert_includes output.string, "Goodbye!"
  end
end
