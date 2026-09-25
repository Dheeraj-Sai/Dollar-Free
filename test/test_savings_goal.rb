# frozen_string_literal: true

require_relative "test_helper"

class SavingsGoalTest < Minitest::Test
  def test_stores_target_days_and_daily_amount
    goal = SavingsGoal.new(target_amount: BigDecimal("300"), days: 30)

    assert_equal BigDecimal("300"), goal.target_amount
    assert_equal 30, goal.days
    assert_equal BigDecimal("10"), goal.daily_amount
  end

  def test_rounds_the_daily_amount_up_to_a_cent
    goal = SavingsGoal.new(target_amount: BigDecimal("100"), days: 3)

    assert_equal BigDecimal("33.34"), goal.daily_amount
  end

  def test_tracks_saved_and_remaining_amounts
    goal = SavingsGoal.new(target_amount: BigDecimal("100"), days: 10)

    goal.add_saved_amount(BigDecimal("25"))

    assert_equal BigDecimal("25"), goal.saved_amount
    assert_equal BigDecimal("75"), goal.remaining_amount
    assert_equal BigDecimal("25"), goal.progress_percentage
  end

  def test_caps_progress_at_one_hundred_percent
    goal = SavingsGoal.new(target_amount: BigDecimal("100"), days: 10)

    goal.add_saved_amount(BigDecimal("125"))

    assert_equal BigDecimal("0"), goal.remaining_amount
    assert_equal BigDecimal("100"), goal.progress_percentage
  end

  def test_converts_to_hash_for_saving
    goal = SavingsGoal.new(target_amount: BigDecimal("100"), days: 10, saved_amount: BigDecimal("25"))

    expected = {
      "target_amount" => "100.0",
      "days" => 10,
      "saved_amount" => "25.0"
    }

    assert_equal expected, goal.to_h
  end

  def test_loads_from_hash
    attributes = {
      "target_amount" => "100.0",
      "days" => 10,
      "saved_amount" => "25.0"
    }
    goal = SavingsGoal.from_h(attributes)

    assert_equal BigDecimal("100"), goal.target_amount
    assert_equal 10, goal.days
    assert_equal BigDecimal("25"), goal.saved_amount
    assert_equal BigDecimal("10"), goal.daily_amount
  end

  def test_loads_from_hash_with_default_saved_amount
    goal = SavingsGoal.from_h("target_amount" => "50.0", "days" => 5)

    assert_equal BigDecimal("0"), goal.saved_amount
  end
end
