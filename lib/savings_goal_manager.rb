require "bigdecimal"
require "fileutils"
require "json"
require_relative "savings_goal"

# Keeps the savings goals made while the program is running.
class SavingsGoalManager
  DEFAULT_STORE_PATH = File.expand_path("../data/savings_goals.json", __dir__)

  attr_reader :goals, :store_path

  def initialize(store_path: DEFAULT_STORE_PATH)
    @store_path = store_path
    @goals = load_goals
  end

  def add_goal(target_amount:, days:)
    goal = SavingsGoal.new(
      target_amount: validate_target_amount(target_amount),
      days: validate_days(days)
    )
    goals.push(goal)
    save_goals
    goal
  end

  def add_progress(goal_number:, amount:)
    goal = find_goal(goal_number)
    goal.add_saved_amount(validate_progress_amount(amount))
    save_goals
    goal
  end

  def savings_goal_menu(input: $stdin, output: $stdout)
    loop do
      display_menu(output: output)

      case input.gets.to_s.strip
      when "1"
        prompt_for_goal(input: input, output: output)
      when "2"
        display_goals(output: output)
      when "3"
        prompt_for_progress(input: input, output: output)
      when "4", ""
        return
      else
        output.puts "Invalid option. Please enter 1, 2, 3, or 4."
      end
    end
  end

  def prompt_for_goal(input: $stdin, output: $stdout)
    output.puts "Set a Savings Goal"
    output.print "Target savings amount: "
    target_amount = input.gets
    output.print "Number of days: "
    days = input.gets

    goal = add_goal(target_amount: target_amount, days: days)
    output.puts "Savings goal added successfully!"
    output.puts "You need to save #{format_amount(goal.daily_amount)} per day."
    goal
  rescue ArgumentError => e
    output.puts "Unable to set savings goal: #{e.message}"
    nil
  end

  def display_goals(output: $stdout)
    output.puts "Your Savings Goals"
    if goals.empty?
      output.puts "No savings goals have been added yet."
      return
    end

    goals.each_with_index do |goal, index|
      day_word = goal.days == 1 ? "day" : "days"
      output.puts "#{index + 1}. Target: #{format_amount(goal.target_amount)} | " \
                  "Time: #{goal.days} #{day_word} | Daily: #{format_amount(goal.daily_amount)} | " \
                  "Saved: #{format_amount(goal.saved_amount)} | " \
                  "Remaining: #{format_amount(goal.remaining_amount)} | " \
                  "Progress: #{format_percentage(goal.progress_percentage)}"
    end
  end

  def prompt_for_progress(input: $stdin, output: $stdout)
    if goals.empty?
      output.puts "No savings goals have been added yet."
      return nil
    end

    output.puts "Add Savings Progress"
    display_goals(output: output)
    output.print "Choose a goal number: "
    goal_number = input.gets
    output.print "Amount saved: "
    amount = input.gets

    goal = add_progress(goal_number: goal_number, amount: amount)
    output.puts "Progress added successfully!"
    output.puts "This goal is now #{format_percentage(goal.progress_percentage)} complete."
    goal
  rescue ArgumentError => e
    output.puts "Unable to add savings progress: #{e.message}"
    nil
  end

  private

  def display_menu(output:)
    output.puts "\nSavings Goals"
    output.puts "1. Set a new savings goal"
    output.puts "2. View savings goals"
    output.puts "3. Add savings progress"
    output.puts "4. Return to main menu"
    output.print "Choose an option: "
  end

  def validate_target_amount(target_amount)
    value = target_amount.to_s.strip
    raise ArgumentError, "Target amount is required." if value.empty?

    begin
      amount = BigDecimal(value)
    rescue ArgumentError
      raise ArgumentError, "Target amount must be a valid number."
    end

    raise ArgumentError, "Target amount must be greater than zero." unless amount.positive?

    amount
  end

  def validate_days(days)
    value = days.to_s.strip
    raise ArgumentError, "Number of days is required." if value.empty?
    raise ArgumentError, "Number of days must be a whole number." unless value.match?(/\A[+-]?\d+\z/)

    number_of_days = value.to_i
    raise ArgumentError, "Number of days must be greater than zero." unless number_of_days.positive?

    number_of_days
  end

  def validate_progress_amount(amount)
    value = amount.to_s.strip
    raise ArgumentError, "Savings amount is required." if value.empty?

    begin
      saved_amount = BigDecimal(value)
    rescue ArgumentError
      raise ArgumentError, "Savings amount must be a valid number."
    end

    raise ArgumentError, "Savings amount must be greater than zero." unless saved_amount.positive?

    saved_amount
  end

  def find_goal(goal_number)
    value = goal_number.to_s.strip
    raise ArgumentError, "Goal number must be a whole number." unless value.match?(/\A\d+\z/)

    index = value.to_i - 1
    return goals[index] if index.between?(0, goals.length - 1)

    raise ArgumentError, "Goal number must be between 1 and #{goals.length}."
  end

  def load_goals
    return [] unless File.exist?(store_path)

    contents = File.read(store_path).strip
    return [] if contents.empty?

    JSON.parse(contents).map { |attributes| SavingsGoal.from_h(attributes) }
  end

  def save_goals
    FileUtils.mkdir_p(File.dirname(store_path))
    File.write(store_path, "#{JSON.pretty_generate(goals.map(&:to_h))}\n")
  end

  def format_amount(amount)
    format("$%.2f", amount)
  end

  def format_percentage(percentage)
    format("%.2f%%", percentage)
  end
end
