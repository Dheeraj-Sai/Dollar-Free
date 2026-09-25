# Done

- Main menu
  - show the 8 options when the app starts
  - read the number and go to the right section
  - wrong number shows an error and goes back to the menu
  - option 8 exits

- Add expense
  - Expense and ExpenseManager classes
  - ask for the category and the amount
  - category has to be one of the 8 we allow
  - reject 0, negative amounts, and anything that is not a number
  - tests for good input and bad input

- View expenses
  - list everything that has been added so far
  - number each row and show the date, category and amount
  - show a message when there is nothing to list

- Daily report
  - pick out only the expenses from today
  - add them up and print the total
  - message when nothing was spent today

- Save expenses to a file
  - write to data/expenses.json whenever an expense is added
  - read the file back when the app starts
  - tests point at a temp file so they do not touch the real one
  - added a date to Expense, otherwise the daily report had nothing to filter on

- Savings goal
  - set target amount and number of days
  - validate the inputs and calculate the daily amount
  - add more than one goal and view the goal list
  - manually add savings progress and save goals to data/savings_goals.json

- Financial health
  - set and update user budget and save to data/budget.json
  - compare budget against total expenses from ExpenseManager
  - calculate remaining amount, spending percentage, and health score (0 to 100)
  - report status tiers and give practical student advice

# To do

- Spending graph
  - group the expenses by category
  - print simple bars in the terminal

- Achievements
  - rules not decided yet

# Notes

Spending graph is next. It can group the expenses we already load from the
file, so there is nothing new to set up for it.

Achievements is optional. It will be worked on only if there is time after the
other planned features.
