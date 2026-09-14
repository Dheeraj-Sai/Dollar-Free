# Dollar Free 💰

Dollar Free is a Ruby terminal application for recording expenses and building
healthier spending habits. It is being developed incrementally through small,
tested user stories.

## Current functionality

The application currently provides:

- A main menu displayed when the application starts.
- An **Add Expense** workflow.
- Expense categories and amount validation.
- In-memory expense storage for the current application session.
- Helpful messages for invalid menu choices, categories, and amounts.

The remaining menu sections are visible so users can see the planned
application structure. They display a clear "not available yet" message until
their feature stories are implemented.

## Requirements

- Ruby (no external gems are required)

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

Expenses are stored only while the application is running. Saving expenses to
a file or database is a future enhancement.

## Run the tests

The project uses Ruby's built-in Minitest framework. Run all tests from the
project root:

```bash
ruby -Ilib:test -e 'Dir["test/test_*.rb"].sort.each { |file| require_relative file }'
```

## Project structure

```text
bin/
  dollar_free          Application entry point
lib/
  expense.rb           Expense data object
  expense_manager.rb   Expense creation, validation, and session storage
  main_menu.rb         Menu display and navigation
test/
  test_expense.rb
  test_expense_manager.rb
  test_main_menu.rb
user_stories_add_expense.txt  Implemented feature stories and acceptance criteria
```

## Development approach

Each feature is implemented as a focused user story with automated tests. The
main menu already provides navigation points for planned features:

1. View Expenses
2. Daily Report
3. Financial Health
4. Spending Graph
5. Savings Goal
6. Achievements

These options will become functional as their respective stories are added.

## License

This project is licensed under the terms in [LICENSE](LICENSE).
