require "bigdecimal"
require "date"
require "fileutils"
require "json"
require_relative "expense"

class ExpenseManager
  DEFAULT_CATEGORIES = ["Food", "Transport", "Housing", "Utilities", "Health", "Education", "Entertainment", "Other"].freeze
  DEFAULT_STORE_PATH = File.expand_path("../data/expenses.json", __dir__)

  attr_reader :expenses, :categories, :store_path

  def initialize(categories: DEFAULT_CATEGORIES, store_path: DEFAULT_STORE_PATH)
    @categories = categories.map { |category| category.to_s.strip }.freeze
    @store_path = store_path
    @expenses = load_expenses
  end

  def add_expense(category:, amount:)
    expense = Expense.new(
      category: validate_category(category),
      amount: validate_amount(amount)
    )
    @expenses.push(expense)
    save_expenses
    return expense
  end

  def prompt_for_expense(input: $stdin, output: $stdout)
    output.puts "Add Expense"
    output.puts "Available categories: #{categories.join(', ')}"
    output.print "Expense type: "
    category = input.gets
    output.print "Amount: "
    amount = input.gets

    expense = add_expense(category: category, amount: amount)
    output.puts "Expense added successfully!"
    expense
  rescue ArgumentError => error
    output.puts "Unable to add expense: #{error.message}"
    nil
  end

  def display_expenses(output: $stdout)
    output.puts "Your Expenses"
    if expenses.empty?
      output.puts "No expenses recorded to be shown."
      return
    end
    index = 0
    while index < expenses.length
      expense = expenses[index]
      number = index + 1
      amount = expense.amount.to_s("F")
      output.puts "#{number}. #{expense.date} - #{expense.category} - #{amount}"
      index += 1
    end
  end

  def generate_daily_report(output: $stdout, date: Date.today)
    output.puts "Daily Report for #{date}"
    todays_expenses = expenses_on(date)
    if todays_expenses.empty?
      output.puts "No expenses recorded today."
      return
    end

    total = BigDecimal("0")
    index = 0
    while index < todays_expenses.length
      expense = todays_expenses[index]
      number = index + 1
      amount = expense.amount.to_s("F")
      output.puts "#{number}. #{expense.category} - #{amount}"
      total = total + expense.amount
      index += 1
    end
    output.puts "Total spent: #{total.to_s('F')}"
  end

  private

  def expenses_on(date)
    matching = []
    index = 0
    while index < expenses.length
      expense = expenses[index]
      if expense.date == date
        matching.push(expense)
      end
      index += 1
    end
    return matching
  end

  def load_expenses
    return [] unless File.exist?(store_path)

    contents = File.read(store_path).strip
    return [] if contents.empty?

    JSON.parse(contents).map { |attributes| Expense.from_h(attributes) }
  end

  def save_expenses
    FileUtils.mkdir_p(File.dirname(store_path))
    File.write(store_path, "#{JSON.pretty_generate(expenses.map(&:to_h))}\n")
  end

  def validate_category(category)
    value = category.to_s.strip
    raise ArgumentError, "Expense category is required." if value.empty?
    matching_category = categories.find { |allowed| allowed.casecmp?(value) }
    unless matching_category
      raise ArgumentError, "Invalid expense category '#{value}'. Choose one of: #{categories.join(', ')}."
    end
    matching_category
  end

  def validate_amount(amount)
    value = amount.to_s.strip
    raise ArgumentError, "Expense amount is required." if value.empty?
    parsed_amount = BigDecimal(value)
    raise ArgumentError, "Expense amount must be greater than zero." unless parsed_amount.positive?
    parsed_amount
  rescue ArgumentError
    raise ArgumentError, "Expense amount must be a valid number." unless value.match?(/\A[+-]?(?:\d+(?:\.\d*)?|\.\d+)\z/)
    raise
  end
end
