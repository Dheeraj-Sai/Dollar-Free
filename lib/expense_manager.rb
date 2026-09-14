# frozen_string_literal: true

require "bigdecimal"
require_relative "expense"

# Creates and retains the expenses entered during the application's lifetime.
class ExpenseManager
  DEFAULT_CATEGORIES = ["Food", "Transport", "Housing", "Utilities", "Health", "Education", "Entertainment", "Other"].freeze

  attr_reader :expenses, :categories

  def initialize(categories: DEFAULT_CATEGORIES)
    @categories = categories.map { |category| category.to_s.strip }.freeze
    @expenses = []
  end

  def add_expense(category:, amount:)
    expense = Expense.new(
      category: validate_category(category),
      amount: validate_amount(amount)
    )
    @expenses << expense
    expense
  end

  # Terminal-facing workflow. Input and output are injectable to keep the
  # interaction usable in a CLI and straightforward to test.
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

  private

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
