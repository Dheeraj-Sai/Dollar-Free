require "bigdecimal"
require "date"
require "fileutils"
require "json"
require_relative "expense"

# Holds the expenses and does the work on them: checking input, adding,
# listing, reporting, and saving to and loading from the JSON file.
class ExpenseManager
  DEFAULT_CATEGORIES = %w[Food Transport Housing Utilities Health Education Entertainment
                          Other].freeze
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
  rescue ArgumentError => e
    output.puts "Unable to add expense: #{e.message}"
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
      total += expense.amount
      index += 1
    end
    output.puts "Total spent: #{total.to_s('F')}"
  end

  def prompt_for_spending_graph(input: $stdin, output: $stdout)
    output.puts "Spending Graph"
    output.print "Enter date (mm/dd/yyyy): "
    date_text = input.gets

    date = parse_graph_date(date_text)
    generate_spending_graph(date: date, output: output)
  rescue ArgumentError => e
    output.puts "Unable to show spending graph: #{e.message}"
  end

  def generate_spending_graph(output: $stdout, date: Date.today)
    output.puts "Spending Graph for #{date}"
    todays_expenses = expenses_on(date)
    if todays_expenses.empty?
      output.puts "No expenses recorded today."
      return
    end

    totals = category_totals(todays_expenses)
    graph_categories = visible_categories_for(totals)
    top_value, step = graph_scale(totals)

    print_graph_rows(totals, graph_categories, top_value, step, output)
    print_graph_axis(graph_categories, output)
  end

  private

  def expenses_on(date)
    matching = []
    index = 0
    while index < expenses.length
      expense = expenses[index]
      matching.push(expense) if expense.date == date
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

  def parse_graph_date(text)
    value = text.to_s.strip
    raise ArgumentError, "Date is required." if value.empty?

    begin
      Date.strptime(value, "%m/%d/%Y")
    rescue ArgumentError
      raise ArgumentError, "Date must be in mm/dd/yyyy format."
    end
  end

  def category_totals(expense_list)
    totals = {}
    index = 0
    while index < expense_list.length
      expense = expense_list[index]
      if totals[expense.category]
        totals[expense.category] += expense.amount
      else
        totals[expense.category] = expense.amount
      end
      index += 1
    end
    return totals
  end

  def visible_categories_for(totals)
    visible = []
    index = 0
    while index < categories.length
      category = categories[index]
      amount = totals[category]
      visible.push(category) if amount&.positive?
      index += 1
    end
    return visible
  end

  def graph_scale(totals)
    highest_amount = BigDecimal("0")
    index = 0
    while index < categories.length
      amount = totals[categories[index]]
      highest_amount = amount if amount && amount > highest_amount
      index += 1
    end

    return [1000, 50] if highest_amount > BigDecimal("200")

    return [200, 10]
  end

  def print_graph_rows(totals, graph_categories, top_value, step, output)
    row_value = top_value
    while row_value >= step
      line = "#{row_value.to_s.rjust(4)} | "
      index = 0
      while index < graph_categories.length
        category = graph_categories[index]
        line += bar_symbol(totals[category], row_value, category.length)
        line += " "
        index += 1
      end
      output.puts line
      row_value -= step
    end
  end

  def bar_symbol(amount, row_value, width)
    capped_amount = amount > 1000 ? BigDecimal("1000") : amount
    return "*" * width if capped_amount >= row_value

    return " " * width
  end

  def print_graph_axis(graph_categories, output)
    axis_line = "#{'0'.rjust(4)} | "
    label_line = " " * 7
    index = 0
    while index < graph_categories.length
      category = graph_categories[index]
      axis_line += "-" * category.length
      axis_line += " "
      label_line += category
      label_line += " "
      index += 1
    end
    output.puts axis_line
    output.puts label_line
  end

  def validate_amount(amount)
    value = amount.to_s.strip
    raise ArgumentError, "Expense amount is required." if value.empty?

    begin
      parsed_amount = BigDecimal(value)
    rescue ArgumentError
      raise ArgumentError, "Expense amount must be a valid number."
    end

    raise ArgumentError, "Expense amount must be greater than zero." unless parsed_amount.positive?

    parsed_amount
  end
end
