# Dollar Free

Dollar Free is a small Ruby terminal project for keeping track of expenses.
The main idea is that a user can enter expenses and later use the app to see
how they are spending money.

## What is done so far

Right now, the app has a main menu, Add Expense, View Expenses, Daily Report,
and Savings Goals.

- The main menu is shown when the program starts.
- Option 1 lets the user add an expense.
- Option 2 shows all the expenses that have been added.
- Option 3 shows only today's expenses and the total spent today.
- Option 6 lets the user add and view daily savings goals.
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
git clone https://github.com/Dheeraj-Sai/Dollar-Free.git
cd Dollar-Free
```

If you already have the project on your computer, just go to the folder where
you saved it:

```bash
cd path/to/Dollar-Free
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

Type a number and press Enter. For now, `1`, `2`, `3`, `6`, and `8` are the
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

## Savings goals

Choose option `6` to open the Savings Goal menu. From there, choose `1` to set
a new goal, `2` to view all goals, `3` to add savings progress, or `4` to go
back to the main menu.

The app asks for a target amount and how many days you have to save it. It then
calculates how much should be saved each day. The daily amount is rounded up to
the nearest cent, so the full target can still be reached.

```text
Target savings amount: 100
Number of days: 3
Savings goal added successfully!
You need to save $33.34 per day.
```

The target must be greater than zero and the number of days must be a whole
number greater than zero.

To update progress, choose option `3`, select a goal number, and enter the
amount you saved. The goal list shows the amount saved, amount remaining, and
percentage complete.

```text
Choose a goal number: 1
Amount saved: 25
Progress added successfully!
This goal is now 25.00% complete.
```

Goals and their progress are saved in `data/savings_goals.json`, so they are
still available when the app is opened again.

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

## Checking the code style

The project uses RuboCop to check that the code is written in a consistent
style. Install it once:

```bash
gem install rubocop
```

Then check the whole project from the project folder:

```bash
rubocop
```

It should report no offenses. The rules are in `.rubocop.yml`, and every rule
the team turned off has a comment saying why.

## Files in the project

```text
bin/dollar_free          starts the program
lib/expense.rb           stores one expense
lib/expense_manager.rb   checks, adds, shows, and saves expenses
lib/main_menu.rb         shows the main menu
lib/savings_goal.rb      stores one savings goal
lib/savings_goal_manager.rb  creates, updates, saves, and lists savings goals
data/expenses.json       the saved expenses (not committed to Git)
data/savings_goals.json  saved savings goals and progress (not committed to Git)
test/                    tests for the code
docs/                    user stories, design, and planning notes
Gemfile                  says which gems the project uses
.rubocop.yml             the code style rules and why they were chosen
user_stories_add_expense.txt  earlier user stories and acceptance criteria
user_stories_savings_goal.txt savings-goal story and acceptance criteria
```

## Features to add later

- Financial health
- Spending graph
- Achievements

## Known limitations

- The expenses are kept in one JSON file on your computer. There is no
  database, and there is no way to share expenses between two people.
- The whole file is rewritten every time an expense is added. This is fine for
  a few hundred expenses, but it would be slow for a very large file.
- An expense cannot be edited or deleted after it is added.
- The date of an expense is always the day it was entered. There is no way to
  add an expense for an earlier day.
- The Daily Report only covers today. There is no weekly or monthly report.
- Financial Health, Spending Graph, and Achievements are not
  built yet. Those menu options say that the feature is not available.
- If the saved file is damaged, the app stops with an error instead of opening.
  This is on purpose, so that real records are not quietly replaced.

## Team members

- Purna Vasanth Repalle
- Dheeraj Sai Madhalam

## Extra project documents

- `docs/user_stories.md` has the stories and acceptance criteria.
- `docs/design.md` explains the current design.
- `docs/backlog.md` shows done and planned work.
- `docs/planning.md` has the initial plan.
- `docs/pairing_log.md` and `docs/retrospective.md` need to be completed with
  the team's real sessions and reflections.

## License

See the [LICENSE](LICENSE) file.
