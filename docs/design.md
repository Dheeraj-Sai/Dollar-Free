# Design Notes

## Basic design

Dollar Free is a terminal application. `bin/dollar_free` starts the program
and creates a `MainMenu` object. The menu receives the user's choice and sends
options 1, 2, and 3 to `ExpenseManager`. The expenses themselves are kept in a
JSON file.

```text
bin/dollar_free
       |
       v
   MainMenu
       |
       +--> ExpenseManager --> Expense
                 |
                 v
        data/expenses.json
```

## Classes

| Class | Job |
| --- | --- |
| `MainMenu` | Shows the menu, reads a choice, and sends the user to a section. |
| `ExpenseManager` | Gets the category and amount, checks them, adds the expense, shows the list, builds the daily report, and saves and loads the file. |
| `Expense` | Stores the category, amount, and date for one expense, and turns itself into a plain Hash for saving. |

## Main methods on `ExpenseManager`

| Method | Job |
| --- | --- |
| `add_expense` | Checks the input, adds the expense to the list, and saves the file. |
| `prompt_for_expense` | Asks the user for a category and amount, then calls `add_expense`. |
| `display_expenses` | Prints every expense that has been recorded. |
| `generate_daily_report` | Prints one day's expenses and the total spent that day. |
| `load_expenses` | Reads the JSON file when the app starts. |
| `save_expenses` | Writes the whole list back to the JSON file. |

## User flow

```text
Start app
  -> Main menu
  -> Choose 1, 2, or 3
  -> 1: enter a category and amount, see a success or error message
  -> 2: see the list of all recorded expenses
  -> 3: see today's expenses and the total spent today
  -> Return to main menu
```

## Decisions made so far

- Expenses are saved in `data/expenses.json`. The file is read once when the
  app starts, and written again every time an expense is added. While the app
  runs, the expenses are held in an array, and every screen reads from that
  array. This keeps one clear answer to "what are my expenses", instead of two
  copies that could disagree.
- The amount is saved as text rather than a number, because JSON numbers would
  lose the exact value that `BigDecimal` is there to protect.
- If the saved file is damaged, the app stops with an error instead of starting
  with an empty list. Showing an empty list would look normal, and the next
  expense added would replace the real records.
- `ExpenseManager` takes the path of the file as a setting. The tests pass in a
  temporary file, so running the tests never touches the user's real data.
- Amounts use `BigDecimal` instead of regular floats so values such as 15.50
  are handled more safely.
- Input and output can be passed into the classes. This makes terminal input
  work normally and also makes the program easier to test with `StringIO`.

## Current menu mock-up

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
