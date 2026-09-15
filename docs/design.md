# Design Notes

## Basic design

Dollar Free is a terminal application. `bin/dollar_free` starts the program
and creates a `MainMenu` object. The menu receives the user's choice and sends
option 1 to `ExpenseManager`.

```text
bin/dollar_free
       |
       v
   MainMenu
       |
       +--> ExpenseManager --> Expense
```

## Classes

| Class | Job |
| --- | --- |
| `MainMenu` | Shows the menu, reads a choice, and sends the user to a section. |
| `ExpenseManager` | Gets the category and amount, validates them, and keeps expenses for the current session. |
| `Expense` | Stores the category and amount for one expense. |

## User flow

```text
Start app
  -> Main menu
  -> Choose 1
  -> Enter category and amount
  -> See success message or error message
  -> Return to main menu
```

## Decisions made so far

- Expenses are kept in an array for now because saving to a file or database is
  not part of the first story.
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
