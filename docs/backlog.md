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

# To do

- Financial health
  - have to decide the budget rule first
  - then show how much is left

- Spending graph
  - group the expenses by category
  - print simple bars in the terminal

- Savings goal
  - user sets a goal amount
  - compare the goal against what has been spent

- Achievements
  - rules not decided yet

# Notes

Financial health is next. It can use the expenses we already load from the
file, so there is nothing new to set up for it.

Savings goal and achievements are the optional ones. We will only get to them
if there is time left after the graph.
