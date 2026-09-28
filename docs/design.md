# Design Notes

## How it is put together

`bin/dollar_free` starts the app. It makes a MainMenu and calls run on it.
That is the only thing in the file.

There are seven classes in lib:

- MainMenu
  - prints the menu and reads the number the user typed
  - calls ExpenseManager, SavingsGoalManager, and FinancialHealthManager for
    the option the user picked
  - does not know anything about expenses, goals, or budgets itself

- ExpenseManager
  - checks the category and the amount
  - adds an expense, lists them, builds the daily report, and draws the
    spending graph
  - reads and writes the JSON file

- Expense
  - holds the category, amount and date for one expense
  - can turn itself into a Hash for saving

- SavingsGoalManager
  - shows the Savings Goal submenu
  - validates, saves, and loads goals and their savings progress
  - draws the savings progress bar for a goal the user picks

- SavingsGoal
  - holds one target amount, number of days, and the daily saving amount

- FinancialHealthManager
  - shows the Financial Health submenu
  - tracks and saves the user budget
  - asks FinancialHealth to do the scoring and prints the report

- FinancialHealth
  - takes a budget, the expenses, and the savings goals
  - calculates the health score, status, runway, and advice
  - has no menu code and does not read or write any file

## Where the data goes

Expenses live in data/expenses.json. The file is read once when the app opens.
After that everything works off the array in memory, and the file gets written
again each time an expense is added.

Savings goals live in data/savings_goals.json. Goals are loaded when the app
starts and written again whenever a goal or its progress changes.

The budget lives in data/budget.json. It is read when the app starts and saved
whenever the user updates their budget.

## Decisions we made

- Amounts use BigDecimal instead of a normal decimal number. With normal
  numbers 15.50 can come out slightly wrong after a few sums.
- The amount is saved as text in the JSON, not as a number. JSON numbers would
  undo the point of using BigDecimal.
- Input and output are passed into the classes instead of printing straight to
  the screen. This is what lets the tests feed in fake input and read the
  output back.
- View Expenses reads the array, not the file. If both the array and the file
  were being read there would be two answers to the same question.
- If the saved file is broken the app stops with an error. We tried letting it
  start empty instead, but then the next expense added would overwrite the real
  records and the user would never know.
- ExpenseManager takes the file path as a setting so the tests can pass a temp
  file and leave the real one alone.
- Savings progress is entered manually because the app only records expenses.
  It does not know a user's income or the amount they actually put into savings.
- Financial health compares total expenses directly against the user budget,
  providing a 0-100 score and tier-based status to keep financial standing clear
  and actionable for students.
- FinancialHealth only calculates; it does not print or save anything. That
  is left to FinancialHealthManager, so the scoring logic can be tested
  without touching input, output, or a file.
- The Spending Graph and Savings Progress bars both use the block character
  `█` for the filled part, and Savings Progress uses `░` for the unfilled
  part. Plain characters like `#` and `-` would also have worked, but the
  block characters look closer to a real progress bar.
- The Spending Graph switches its y-axis from 0-200 to 0-1000 only when a
  category's total for that date goes over 200. One fixed scale would either
  waste space on a normal day or squash a day with one big expense.
- We planned to build Achievements, but it needed badge rules and progress
  tracking that felt too big for this project. We replaced it with Savings
  Progress instead, since a progress bar reuses data the app already saves.

## What the menu looks like

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
Choose an option:
```
