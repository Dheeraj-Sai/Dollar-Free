require "bigdecimal"
require "fileutils"
require "json"
require_relative "financial_health"

# Manages the user budget, persists it to JSON, and shows the financial health menu.
class FinancialHealthManager
  DEFAULT_STORE_PATH = File.expand_path("../data/budget.json", __dir__)

  attr_reader :expense_manager, :savings_goal_manager, :store_path, :budget

  def initialize(expense_manager:, savings_goal_manager: nil, store_path: DEFAULT_STORE_PATH)
    @expense_manager = expense_manager
    @savings_goal_manager = savings_goal_manager
    @store_path = store_path
    @budget = load_budget
  end

  def update_budget(amount)
    @budget = validate_budget(amount)
    save_budget
    @budget
  end

  def financial_health
    return nil unless budget

    goals = savings_goal_manager ? savings_goal_manager.goals : []
    FinancialHealth.new(budget: budget, expenses: expense_manager.expenses, goals: goals)
  end

  def financial_health_menu(input: $stdin, output: $stdout)
    loop do
      display_menu(output: output)

      case input.gets.to_s.strip
      when "1"
        display_report(input: input, output: output)
      when "2"
        prompt_for_budget(input: input, output: output)
      when "3", ""
        return
      else
        output.puts "Invalid option. Please enter 1, 2, or 3."
      end
    end
  end

  def prompt_for_budget(input: $stdin, output: $stdout)
    output.puts "Set Budget"
    output.print "Enter your budget: "
    amount = input.gets

    new_budget = update_budget(amount)
    output.puts "Budget updated to #{format_amount(new_budget)} successfully!"
    new_budget
  rescue ArgumentError => e
    output.puts "Unable to set budget: #{e.message}"
    nil
  end

  def display_report(input: $stdin, output: $stdout)
    health = financial_health
    if health.nil?
      output.puts "No budget has been set yet. Please set your budget first."
      return prompt_for_budget(input: input, output: output)
    end

    print_report_header(output, health)
    print_score_breakdown(output, health)
    print_insights(output, health)
  end

  private

  def display_menu(output:)
    output.puts "\nFinancial Health"
    output.puts "1. View financial health report"
    output.puts "2. Set or update budget"
    output.puts "3. Return to main menu"
    output.print "Choose an option: "
  end

  def print_report_header(output, health)
    output.puts "\nStudent Financial Health Report"
    output.puts "Overall Health Score: #{health.health_score}/100 [ #{health.status_label} ]"
    output.puts "Budget: #{format_amount(budget)} | Total Spent: #{format_amount(health.total_expenses)} | " \
                "Remaining: #{format_remaining(health.remaining_budget)}"
  end

  def print_score_breakdown(output, health)
    wants_pct = format_percentage(health.discretionary_percentage)
    output.puts "\nScore Breakdown:"
    output.puts "- Budget Control: #{health.budget_score}/35"
    output.puts "- Burn Rate & Pace: #{health.pace_score}/30 (Daily: #{format_amount(health.daily_pace)} vs " \
                "Safe: #{format_amount(health.safe_daily_allowance)})"
    output.puts "- Category Balance: #{health.category_score}/20 (Wants: #{wants_pct})"
    output.puts "- Savings Momentum: #{health.savings_score}/15"
  end

  def print_insights(output, health)
    output.puts "\nInsights & Forecast:"
    print_runway_insight(output, health)
    print_category_insight(output, health)
    output.puts "- Advice: #{health.actionable_advice}"
  end

  def print_runway_insight(output, health)
    if health.remaining_budget <= 0
      over = health.total_expenses - budget
      output.puts "- Runway: Exhausted! You have exceeded your budget by #{format_amount(over)}."
    else
      output.puts "- Runway: At your current pace, your remaining budget will last #{health.runway_days} days."
    end
  end

  def print_category_insight(output, health)
    cat, amount, pct = health.top_category
    if cat
      output.puts "- Top Expense: #{cat} (#{format_amount(amount)} - #{format_percentage(pct)} of spending)."
    else
      output.puts "- Top Expense: None recorded yet."
    end
  end

  def format_remaining(remaining)
    if remaining.negative?
      "#{format_amount(remaining)} (Exceeded by #{format_amount(remaining.abs)})"
    else
      pct_left = ((remaining / budget) * 100).round(2)
      "#{format_amount(remaining)} (#{format_percentage(pct_left)} remaining)"
    end
  end

  def validate_budget(amount)
    value = amount.to_s.strip
    raise ArgumentError, "Budget amount is required." if value.empty?

    begin
      parsed = BigDecimal(value)
    rescue ArgumentError
      raise ArgumentError, "Budget amount must be a valid number."
    end

    raise ArgumentError, "Budget amount must be greater than zero." unless parsed.positive?

    parsed
  end

  def load_budget
    return nil unless File.exist?(store_path)

    contents = File.read(store_path).strip
    return nil if contents.empty?

    data = JSON.parse(contents)
    BigDecimal(data["budget"].to_s)
  end

  def save_budget
    FileUtils.mkdir_p(File.dirname(store_path))
    File.write(store_path, "#{JSON.pretty_generate({ 'budget' => budget.to_s('F') })}\n")
  end

  def format_amount(amount)
    format("$%.2f", amount)
  end

  def format_percentage(percentage)
    format("%.2f%%", percentage)
  end
end
