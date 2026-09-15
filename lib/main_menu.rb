require_relative "expense_manager"

# Shows the menu and sends the user to the right feature. It does not do any
# expense work itself, it only asks ExpenseManager to do it.
class MainMenu
  def initialize(input: $stdin, output: $stdout, expense_manager: ExpenseManager.new)
    @input = input
    @output = output
    @expense_manager = expense_manager
  end

  def run
    loop do
      display_menu
      break unless process_selection(@input.gets)
    end
  end

  def display_menu
    @output.puts "\n====== Dollar Free ======"
    @output.puts "1. Add Expense"
    @output.puts "2. View Expenses"
    @output.puts "3. Daily Report"
    @output.puts "4. Financial Health"
    @output.puts "5. Spending Graph"
    @output.puts "6. Savings Goal"
    @output.puts "7. Achievements"
    @output.puts "8. Exit"
    @output.print "Choose an option: "
  end

  def process_selection(selection)
    case selection.to_s.strip
    when "1"
      @expense_manager.prompt_for_expense(input: @input, output: @output)
    when "2"
      @expense_manager.display_expenses(output: @output)
    when "3"
      @expense_manager.generate_daily_report(output: @output)
    when "4"
      @output.puts "Financial Health is not available yet."
    when "5"
      @output.puts "Spending Graph is not available yet."
    when "6"
      @output.puts "Savings Goal is not available yet."
    when "7"
      @output.puts "Achievements is not available yet."
    when "8", ""
      @output.puts "Expense Tracker Signing OFF!!!"
      return false
    else
      @output.puts "Invalid option. Please enter a number from 1 to 8."
    end
    true
  end
end
