# Design Notes

## How it is put together

`bin/dollar_free` starts the app. It makes a MainMenu and calls run on it.
That is the only thing in the file.

There are three classes in lib:

- MainMenu
  - prints the menu and reads the number the user typed
  - calls ExpenseManager for options 1, 2 and 3
  - does not know anything about expenses itself

- ExpenseManager
  - checks the category and the amount
  - adds an expense, lists them, and builds the daily report
  - reads and writes the JSON file

- Expense
  - holds the category, amount and date for one expense
  - can turn itself into a Hash for saving

## Where the data goes

Expenses live in data/expenses.json. The file is read once when the app opens.
After that everything works off the array in memory, and the file gets written
again each time an expense is added.

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

## What the menu looks like

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
