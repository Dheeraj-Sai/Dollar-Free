# Dollar Free 💰

Dollar Free is a Ruby terminal application for recording expenses and building
healthier spending habits. It is being developed incrementally through small,
tested user stories.

## Current functionality

The application currently provides:

- A main menu displayed when the application starts.
- An **Add Expense** workflow.
- A **View Expenses** screen listing every recorded expense.
- A **Daily Report** showing one day's expenses and the total spent.
- Expense categories and amount validation.
- Expenses saved to `data/expenses.json`, so they survive restarting the
  application.
- Helpful messages for invalid menu choices, categories, and amounts.

Menu options 4 to 7 are visible so users can see the planned application
structure. They display a clear "not available yet" message until their
feature stories are implemented.

## Requirements

- Ruby (Minitest is the only gem used, and it ships with Ruby)

Check that Ruby is installed:

```bash
ruby --version
```

## Getting started

Clone the repository and move into its directory:

```bash
git clone <repository-url>
cd Dollar-Free
```

If you already have the project locally, open Terminal and move to the project
folder instead:

```bash
cd /Users/dheeraj/Documents/MCS/SWE/projects/Dollar-Free
```

## Run the application

Start Dollar Free with:

```bash
./bin/dollar_free
```

If the command is not executable on your computer, run:

```bash
chmod +x bin/dollar_free
./bin/dollar_free
```

The application opens at the main menu:

```text
====== Dollar Free ======
1. Add Expense
2. View Expenses
3. Daily Report
4. Financial Health
5. Spending Graph
6. Savings Goal
7. Achievements
8. Exit
Choose an option:
```

Enter the number of the feature you want to use. Enter `8` to exit.

## Add an expense

Choose `1` from the main menu. The application asks for a category and an
amount:

```text
Choose an option: 1
Add Expense
Available categories: Food, Transport, Housing, Utilities, Health, Education, Entertainment, Other
Expense type: Food
Amount: 15.50
Expense added successfully!
```

### Valid categories

- Food
- Transport
- Housing
- Utilities
- Health
- Education
- Entertainment
- Other

Categories are case-insensitive. For example, entering `food` stores the
category as `Food`.

### Amount rules

An amount must be a number greater than zero. The application rejects:

- Zero amounts
- Negative amounts
- Text instead of a number
- Missing amounts

For example:

```text
Expense type: Food
Amount: -5
Unable to add expense: Expense amount must be greater than zero.
```

## View expenses

Choose `2` from the main menu to list every expense that has been recorded,
including expenses from previous days:

```text
Choose an option: 2
Your Expenses
1. 2026-09-14 - Food - 15.5
2. 2026-09-13 - Housing - 900.0
```

## Daily report

Choose `3` from the main menu to see only the expenses recorded today, along
with the total spent:

```text
Choose an option: 3
Daily Report for 2026-09-14
1. Food - 15.5
2. Transport - 42.75
Total spent: 58.25
```

## How expenses are stored

Expenses are saved to `data/expenses.json`. The file is read once when the
application starts and rewritten whenever an expense is added, so records are
kept between sessions. While the application is running, expenses are held in
memory and every screen reads from there.

The file is a plain JSON list, and amounts are stored as strings so the exact
value is preserved:

```json
[
  { "category": "Food", "amount": "15.5", "date": "2026-09-14" }
]
```

## Run the tests

The project uses Ruby's built-in Minitest framework. Run all tests from the
project root:

```bash
ruby -Ilib:test -e 'Dir["test/test_*.rb"].sort.each { |file| require File.expand_path(file) }'
```

## Project structure

```text
bin/
  dollar_free          Application entry point
lib/
  expense.rb           Expense data object
  expense_manager.rb   Expense creation, validation, reporting, and storage
  main_menu.rb         Menu display and navigation
data/
  expenses.json        Saved expenses (created on first run, not tracked by git)
test/
  test_helper.rb
  test_expense.rb
  test_expense_manager.rb
  test_main_menu.rb
Gemfile                Declares Minitest, the test framework
user_stories_add_expense.txt  Implemented feature stories and acceptance criteria
```

## Development approach

Each feature is implemented as a focused user story with automated tests. The
main menu already provides navigation points for the remaining features:

1. Financial Health
2. Spending Graph
3. Savings Goal
4. Achievements

These options will become functional as their respective stories are added.

## License

This project is licensed under the terms in [LICENSE](LICENSE).
