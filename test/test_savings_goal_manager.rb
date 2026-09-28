# frozen_string_literal: true

# Unit tests for SavingsGoalManager: goals, progress, the progress bar,
# and its submenu.

require_relative "test_helper"

class SavingsGoalManagerTest < Minitest::Test
  def setup
    @store = Tempfile.new(["savings_goals", ".json"])
    @manager = SavingsGoalManager.new(store_path: @store.path)
  end

  def teardown
    @store.close!
  end

  def test_adds_multiple_savings_goals
    first_goal = @manager.add_goal(target_amount: "300", days: "30")
    second_goal = @manager.add_goal(target_amount: "100", days: "10")

    assert_equal [first_goal, second_goal], @manager.goals
    assert_equal BigDecimal("10"), first_goal.daily_amount
    assert_equal BigDecimal("10"), second_goal.daily_amount
  end

  def test_saves_and_reloads_goals
    @manager.add_goal(target_amount: "300", days: "30")
    @manager.add_progress(goal_number: "1", amount: "75")

    reloaded = SavingsGoalManager.new(store_path: @store.path)

    assert_equal 1, reloaded.goals.length
    assert_equal BigDecimal("300"), reloaded.goals.first.target_amount
    assert_equal 30, reloaded.goals.first.days
    assert_equal BigDecimal("75"), reloaded.goals.first.saved_amount
  end

  def test_adds_progress_to_the_selected_goal
    @manager.add_goal(target_amount: "300", days: "30")

    goal = @manager.add_progress(goal_number: "1", amount: "75.50")

    assert_equal BigDecimal("75.50"), goal.saved_amount
    assert_equal BigDecimal("224.50"), goal.remaining_amount
    assert_equal BigDecimal("25.17"), goal.progress_percentage
  end

  def test_rejects_invalid_target_amounts
    blank_error = assert_raises(ArgumentError) { @manager.add_goal(target_amount: " ", days: "10") }
    text_error = assert_raises(ArgumentError) { @manager.add_goal(target_amount: "one hundred", days: "10") }
    zero_error = assert_raises(ArgumentError) { @manager.add_goal(target_amount: "0", days: "10") }
    negative_error = assert_raises(ArgumentError) { @manager.add_goal(target_amount: "-5", days: "10") }

    assert_equal "Target amount is required.", blank_error.message
    assert_equal "Target amount must be a valid number.", text_error.message
    assert_equal "Target amount must be greater than zero.", zero_error.message
    assert_equal "Target amount must be greater than zero.", negative_error.message
  end

  def test_rejects_invalid_number_of_days
    blank_error = assert_raises(ArgumentError) { @manager.add_goal(target_amount: "100", days: " ") }
    decimal_error = assert_raises(ArgumentError) { @manager.add_goal(target_amount: "100", days: "2.5") }
    zero_error = assert_raises(ArgumentError) { @manager.add_goal(target_amount: "100", days: "0") }
    negative_error = assert_raises(ArgumentError) { @manager.add_goal(target_amount: "100", days: "-2") }

    assert_equal "Number of days is required.", blank_error.message
    assert_equal "Number of days must be a whole number.", decimal_error.message
    assert_equal "Number of days must be greater than zero.", zero_error.message
    assert_equal "Number of days must be greater than zero.", negative_error.message
  end

  def test_rejects_invalid_progress_amounts
    @manager.add_goal(target_amount: "100", days: "10")

    blank_error = assert_raises(ArgumentError) { @manager.add_progress(goal_number: "1", amount: " ") }
    text_error = assert_raises(ArgumentError) { @manager.add_progress(goal_number: "1", amount: "ten") }
    zero_error = assert_raises(ArgumentError) { @manager.add_progress(goal_number: "1", amount: "0") }
    negative_error = assert_raises(ArgumentError) { @manager.add_progress(goal_number: "1", amount: "-10") }

    assert_equal "Savings amount is required.", blank_error.message
    assert_equal "Savings amount must be a valid number.", text_error.message
    assert_equal "Savings amount must be greater than zero.", zero_error.message
    assert_equal "Savings amount must be greater than zero.", negative_error.message
  end

  def test_rejects_invalid_goal_numbers_for_progress
    @manager.add_goal(target_amount: "100", days: "10")

    whole_number_error = assert_raises(ArgumentError) { @manager.add_progress(goal_number: "one", amount: "10") }
    goal_error = assert_raises(ArgumentError) { @manager.add_progress(goal_number: "2", amount: "10") }

    assert_equal "Goal number must be a whole number.", whole_number_error.message
    assert_equal "Goal number must be between 1 and 1.", goal_error.message
  end

  def test_prompts_for_and_adds_a_goal
    input = StringIO.new("300\n30\n")
    output = StringIO.new

    goal = @manager.prompt_for_goal(input: input, output: output)

    assert_equal BigDecimal("300"), goal.target_amount
    assert_includes output.string, "Savings goal added successfully!"
    assert_includes output.string, "You need to save $10.00 per day."
  end

  def test_shows_an_error_for_invalid_goal_input
    input = StringIO.new("100\n2.5\n")
    output = StringIO.new

    result = @manager.prompt_for_goal(input: input, output: output)

    assert_nil result
    assert_includes output.string, "Unable to set savings goal: Number of days must be a whole number."
  end

  def test_displays_a_message_when_there_are_no_goals
    output = StringIO.new

    @manager.display_goals(output: output)

    assert_includes output.string, "No savings goals have been added yet."
  end

  def test_displays_all_goals
    @manager.add_goal(target_amount: "300", days: "30")
    @manager.add_goal(target_amount: "100", days: "3")
    output = StringIO.new

    @manager.display_goals(output: output)

    assert_includes output.string, "1. Target: $300.00 | Time: 30 days | Daily: $10.00"
    assert_includes output.string, "Saved: $0.00 | Remaining: $300.00 | Progress: 0.00%"
    assert_includes output.string, "2. Target: $100.00 | Time: 3 days | Daily: $33.34"
  end

  def test_savings_goal_menu_manages_goals_and_progress
    input = StringIO.new("1\n300\n30\n3\n1\n25\n2\n\n")
    output = StringIO.new

    @manager.savings_goal_menu(input: input, output: output)

    assert_equal 1, @manager.goals.length
    assert_equal BigDecimal("25"), @manager.goals.first.saved_amount
    assert_includes output.string, "Your Savings Goals"
    assert_includes output.string, "Target: $300.00"
    assert_includes output.string, "Progress added successfully!"
  end

  def test_savings_goal_menu_rejects_an_invalid_option
    input = StringIO.new("9\n4\n")
    output = StringIO.new

    @manager.savings_goal_menu(input: input, output: output)

    assert_includes output.string, "Invalid option. Please enter 1, 2, 3, or 4."
  end

  def test_prompts_for_and_adds_savings_progress
    @manager.add_goal(target_amount: "100", days: "10")
    input = StringIO.new("1\n25\n")
    output = StringIO.new

    goal = @manager.prompt_for_progress(input: input, output: output)

    assert_equal BigDecimal("25"), goal.saved_amount
    assert_includes output.string, "Progress added successfully!"
    assert_includes output.string, "This goal is now 25.00% complete."
  end

  def test_progress_prompt_explains_when_there_are_no_goals
    output = StringIO.new

    result = @manager.prompt_for_progress(output: output)

    assert_nil result
    assert_includes output.string, "No savings goals have been added yet."
  end

  def test_progress_prompt_handles_invalid_inputs
    @manager.add_goal(target_amount: "100", days: "10")

    output = StringIO.new
    assert_nil @manager.prompt_for_progress(input: StringIO.new("3\n25\n"), output: output)
    assert_includes output.string, "Unable to add savings progress: Goal number must be between 1 and 1."

    output = StringIO.new
    assert_nil @manager.prompt_for_progress(input: StringIO.new("1\nnot-a-number\n"), output: output)
    assert_includes output.string, "Unable to add savings progress: Savings amount must be a valid number."
  end

  def test_prompt_for_progress_bar_shows_the_bar_for_the_chosen_goal
    @manager.add_goal(target_amount: "300", days: "30")
    @manager.add_progress(goal_number: "1", amount: "165")
    input = StringIO.new("1\n")
    output = StringIO.new

    goal = @manager.prompt_for_progress_bar(input: input, output: output)

    expected_bar = "[#{'█' * 55}▶#{'░' * 44}] 55.00%"

    message = "You've reached the halfway point of your goal. Keep up the great work!"

    assert_equal BigDecimal("165"), goal.saved_amount
    assert_includes output.string, "Savings Progress"
    assert_includes output.string, expected_bar
    assert_includes output.string, message
  end

  def test_prompt_for_progress_bar_shows_a_milestone_message_at_zero_percent
    @manager.add_goal(target_amount: "100", days: "10")
    output = StringIO.new

    @manager.prompt_for_progress_bar(input: StringIO.new("1\n"), output: output)

    message = "No progress yet. Add your first savings to get started!"

    assert_includes output.string, message
  end

  def test_prompt_for_progress_bar_shows_no_milestone_message_below_twenty_five_percent
    @manager.add_goal(target_amount: "100", days: "10")
    @manager.add_progress(goal_number: "1", amount: "20")
    output = StringIO.new

    @manager.prompt_for_progress_bar(input: StringIO.new("1\n"), output: output)

    refute_includes output.string, "No progress yet"
    refute_includes output.string, "You've saved a quarter"
  end

  def test_prompt_for_progress_bar_shows_a_milestone_message_at_twenty_five_percent
    @manager.add_goal(target_amount: "100", days: "10")
    @manager.add_progress(goal_number: "1", amount: "25")
    output = StringIO.new

    @manager.prompt_for_progress_bar(input: StringIO.new("1\n"), output: output)

    message = "You've saved a quarter of your goal. Keep up the steady progress!"

    assert_includes output.string, message
  end

  def test_prompt_for_progress_bar_shows_a_milestone_message_at_fifty_percent
    @manager.add_goal(target_amount: "100", days: "10")
    @manager.add_progress(goal_number: "1", amount: "50")
    output = StringIO.new

    @manager.prompt_for_progress_bar(input: StringIO.new("1\n"), output: output)

    message = "You've reached the halfway point of your goal. Keep up the great work!"

    assert_includes output.string, message
  end

  def test_prompt_for_progress_bar_shows_a_milestone_message_at_seventy_five_percent
    @manager.add_goal(target_amount: "100", days: "10")
    @manager.add_progress(goal_number: "1", amount: "75")
    output = StringIO.new

    @manager.prompt_for_progress_bar(input: StringIO.new("1\n"), output: output)

    message = "You've saved three quarters of your goal. You are almost at the finish line!"

    assert_includes output.string, message
  end

  def test_prompt_for_progress_bar_shows_a_milestone_message_at_one_hundred_percent
    @manager.add_goal(target_amount: "100", days: "10")
    @manager.add_progress(goal_number: "1", amount: "100")
    output = StringIO.new

    @manager.prompt_for_progress_bar(input: StringIO.new("1\n"), output: output)

    message = "You've reached the full amount of your goal. Great job on completing it!"

    assert_includes output.string, message
  end

  def test_prompt_for_progress_bar_explains_when_there_are_no_goals
    output = StringIO.new

    result = @manager.prompt_for_progress_bar(output: output)

    assert_nil result
    assert_includes output.string, "No savings goals have been added yet."
  end

  def test_prompt_for_progress_bar_rejects_an_invalid_goal_number
    @manager.add_goal(target_amount: "100", days: "10")
    input = StringIO.new("2\n")
    output = StringIO.new

    result = @manager.prompt_for_progress_bar(input: input, output: output)

    assert_nil result
    assert_includes output.string, "Unable to show savings progress: Goal number must be between 1 and 1."
  end

  def test_loads_empty_store_file_as_empty_goals
    File.write(@store.path, "   \n")
    manager = SavingsGoalManager.new(store_path: @store.path)

    assert_empty manager.goals
  end
end
