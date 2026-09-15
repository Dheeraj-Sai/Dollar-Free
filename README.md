# Dollar Free

Dollar Free is a small Ruby terminal project for keeping track of expenses.
The main idea is that a user can enter expenses and later use the app to see
how they are spending money.

## What is done so far

Right now, the app has a main menu, Add Expense, View Expenses, and the
Daily Report.

- The main menu is shown when the program starts.
- Option 1 lets the user add an expense.
- Option 2 shows all the expenses that have been added.
- Option 3 shows only today's expenses and the total spent today.
- The amount has to be a number bigger than 0.
- The category has to be one of the categories in the program.
- If the user enters a wrong menu number, the app shows an error message.
- Expenses are saved in a file, so they are still there the next time the
  app is opened.

The main features planned for the project are Add Expense, View Expenses,
Daily Report, Financial Health, Spending Graph, Savings Goal, and Achievements.

The other menu options are there already, but they are not built yet. They
will say that the feature is not available yet.

## How to run it

Make sure Ruby is installed first:

```bash
ruby --version
```

Go inside the project folder:

```bash
cd /Users/dheeraj/Documents/MCS/SWE/projects/Dollar-Free
```

Then start the program:

```bash
./bin/dollar_free
```

If that does not work because of permissions, run this once:

```bash
chmod +x bin/dollar_free
```

Then run `./bin/dollar_free` again.

## Main menu

When the app starts, this is the menu:

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
```

Type a number and press Enter. For now, `1`, `2`, `3`, and `8` are the
options that do something.

## Adding an expense

Choose option `1`. The program asks for the expense type and amount.

Example:

```text
Choose an option: 1
Add Expense
Expense type: Food
Amount: 15.50
Expense added successfully!
```

These are the categories that can be used:

- Food
- Transport
- Housing
- Utilities
- Health
- Education
- Entertainment
- Other

The amount must be greater than zero. For example, `0`, `-10`, or `ten` are
not accepted.

## Viewing expenses

Choose option `2`. It lists every expense that has been added, including the
ones from earlier days.

```text
Choose an option: 2
Your Expenses
1. 2026-09-14 - Food - 15.5
2. 2026-09-13 - Housing - 900.0
```

## Daily report

Choose option `3`. It shows only the expenses from today and adds them up.

```text
Choose an option: 3
Daily Report for 2026-09-14
1. Food - 15.5
2. Transport - 42.75
Total spent: 58.25
```

## Where the expenses are saved

The expenses are kept in `data/expenses.json`. The file is read once when the
app starts, and it is written again every time an expense is added. While the
app is running, the expenses are held in memory and every screen reads from
there.

The file looks like this. The amount is saved as text so the exact value is
kept:

```json
[
  { "category": "Food", "amount": "15.5", "date": "2026-09-14" }
]
```

The file is not committed to Git, because it holds the user's own data.

## Tests

The tests use Minitest, which comes with Ruby. Run them from the project
folder using:

```bash
ruby -Ilib:test -e 'Dir["test/test_*.rb"].sort.each { |file| require File.expand_path(file) }'
```

There are unit tests for the expense and menu classes, plus acceptance tests
that run through the menu like a user would.

### Coverage report

To run the tests and create a simple line-coverage report, use:

```bash
COVERAGE=true ruby -Ilib:test -e 'Dir["test/test_*.rb"].sort.each { |file| require File.expand_path(file) }'
```

The report is created at `coverage/coverage.txt`. The `coverage` folder is
generated automatically and is not committed to Git.

## Files in the project

```text
bin/dollar_free          starts the program
lib/expense.rb           stores one expense
lib/expense_manager.rb   checks, adds, shows, and saves expenses
lib/main_menu.rb         shows the main menu
data/expenses.json       the saved expenses (not committed to Git)
test/                    tests for the code
docs/                    user stories, design, and planning notes
Gemfile                  says which gems the project uses
user_stories_add_expense.txt  user stories and acceptance criteria
```

## Features to add later

- Financial health
- Spending graph
- Savings goal
- Achievements

## Team members

- Add team member names here.

## Extra project documents

- `docs/user_stories.md` has the stories and acceptance criteria.
- `docs/design.md` explains the current design.
- `docs/backlog.md` shows done and planned work.
- `docs/planning.md` has the initial plan.
- `docs/pairing_log.md` and `docs/retrospective.md` need to be completed with
  the team's real sessions and reflections.

## License

See the [LICENSE](LICENSE) file.
