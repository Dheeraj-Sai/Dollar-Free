# Dollar Free

Dollar Free is a small Ruby terminal project for keeping track of expenses.
The main idea is that a user can enter expenses and later use the app to see
how they are spending money.

## What is done so far

- Option 1 lets the user add an expense.
- Option 2 shows all the expenses that have been added.
- Option 3 shows only today's expenses and the total spent today.
- Option 4 lets the user view financial health and manage their budget.
- Option 5 shows a spending graph for a date the user enters.
- Option 6 lets the user add and view daily savings goals.
- Option 7 shows a progress bar for a savings goal the user picks.
- The amount has to be a number bigger than 0.
- The category has to be one of the categories in the program.
- If the user enters a wrong menu number, the app shows an error message.
- Expenses are saved in a file, so they are still there the next time the
  app is opened.

## How to run it

Make sure Ruby is installed (`ruby --version`), then clone the project and go
into its folder (or `cd` into it if you already have it):

```bash
git clone https://github.com/Dheeraj-Sai/Dollar-Free.git
cd Dollar-Free
```

Then start the program:

```bash
./bin/dollar_free
```

If that fails because of permissions, run `chmod +x bin/dollar_free` once,
then try again.

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
7. Savings Progress
8. Exit
```

Type a number and press Enter. Every option from `1` to `8` does something.

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

## Financial health

Choose option `4` to open the Financial Health menu. From there, choose `1` to
view your financial health report, `2` to set or update your budget, or `3` to
return to the main menu.

The report evaluates your finances using a student-friendly 4-pillar Health Index (Total 100 pts: Budget Control 35 pts, Spending Pace 30 pts, Category Balance 20 pts, and Savings Momentum 15 pts) along with budget runway forecasting:

```text
Student Financial Health Report
Overall Health Score: 85/100 [ Healthy (Excellent) ]
Budget: $500.00 | Total Spent: $150.00 | Remaining: $350.00 (70.00% remaining)

Score Breakdown:
- Budget Control: 25/35
- Burn Rate & Pace: 0/30 (Daily: $150.00 vs Safe: $16.67)
- Category Balance: 13/20 (Wants: 53.33%)
- Savings Momentum: 6/15

Insights & Forecast:
- Runway: At your current pace, your remaining budget will last 2 days.
- Top Expense: Entertainment ($80.00 - 53.33% of spending).
- Advice: Slow down! Aim to keep daily spending below $16.67.
```

If spending exceeds the budget, the score drops to 0/100 (Critical), the
remaining amount is shown as negative with an "Exceeded by $X" note, and the
advice switches to a budget-exceeded alert.

The budget is saved in `data/budget.json`, so it persists across sessions.

## Spending graph

Choose option `5` to see a bar graph of one day's spending by category. The
app asks for a date in mm/dd/yyyy format, then draws a bar for each category
that has spending on that date.

```text
Choose an option: 5
Enter date (mm/dd/yyyy): 09/14/2026
Spending Graph for 2026-09-14
 200 |
 ...
 120 |      █████████
 ...
  50 | ████ █████████
  40 | ████ █████████
  30 | ████ █████████
  20 | ████ █████████
  10 | ████ █████████
   0 | ---- ---------
       Food Transport
```

(rows in between are blank until the bar height is reached; shortened here
for length)

The y-axis goes up to 200 by default. If any category's total for that date
is over 200, the graph switches to a scale of 1000 instead, and a single
category's bar is capped at 1000 even if the real amount is higher.
Categories with nothing spent on that date are left off the graph.

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

## Savings progress

Choose option `7` to see a progress bar for one of your savings goals. The
app lists your goals, asks for a goal number, and then draws a bar that fills
up based on how much of that goal has been saved so far, with a small `▶`
marker sitting right at the edge of the filled part. It also prints a short
message once the goal crosses 25%, 50%, 75%, or 100% saved.

```text
Choose an option: 7
Savings Progress
Your Savings Goals
1. Target: $300.00 | Time: 30 days | Daily: $10.00 | Saved: $165.00 | Remaining: $135.00 | Progress: 55.00%
Choose a goal number: 1
[███████████████████████████████████████████████████████▶░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░] 55.00%
You've reached the halfway point of your goal. Keep up the great work!
```

Expenses, goals, and the budget are each saved to their own JSON file in
`data/`, which is not committed to Git since it holds the user's own data.
See `docs/design.md` for when each file is read and written.

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

The project uses RuboCop (`gem install rubocop` if you don't have it). Run
`rubocop` from the project folder; it should report no offenses. Rules that
were changed from the default are explained in `.rubocop.yml`.

See `docs/design.md` for what each file in `lib/` does.

## Features to add later

All of the originally planned features have been built.

## Known limitations

- The expenses are kept in one JSON file on your computer. There is no
  database, and there is no way to share expenses between two people.
- The whole file is rewritten every time an expense is added. This is fine for
  a few hundred expenses, but it would be slow for a very large file.
- An expense cannot be edited or deleted after it is added.
- The date of an expense is always the day it was entered. There is no way to
  add an expense for an earlier day.
- The Daily Report only covers today. There is no weekly or monthly report.
- If the saved file is damaged, the app stops with an error instead of opening.
  This is on purpose, so that real records are not quietly replaced.

## Team members

- Purna Vasanth Repalle
- Dheeraj Sai Madhalam

## Extra project documents

- `docs/user_stories.md` has the stories and acceptance criteria.
- `docs/design.md` explains the current design.
- `docs/backlog.md` shows done and planned work.
- `docs/planning.md` has the initial plan and a later update to it.
- `docs/pairing_log.md` has the team's pairing sessions.
- `docs/retrospective.md` has the team's reflections on the finished project.