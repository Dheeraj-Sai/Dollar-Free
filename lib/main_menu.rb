require_relative "expense_manager"

class MainMenu
  MENU_ITEMS = {
    "1" => "Add Expense",
    "2" => "View Expenses",
    "3" => "Daily Report",
    "4" => "Financial Health",
    "5" => "Spending Graph",
    "6" => "Savings Goal",
    "7" => "Achievements",
    "8" => "Exit"
  }.freeze

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
    MENU_ITEMS.each { |number, label| @output.puts "#{number}. #{label}" }
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
    when "4", "5", "6", "7"
      show_unavailable_section(MENU_ITEMS.fetch(selection.to_s.strip))
    when "8", ""
      @output.puts "Expense Tracker Signing OFF!!!"
      return false
    else
      @output.puts "Invalid option. Please enter a number from 1 to 8."
    end
    true
  end

  private

  def show_unavailable_section(section_name)
    @output.puts "#{section_name} is not available yet."
  end
end
