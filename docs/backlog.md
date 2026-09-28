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
  - evaluate 4 distinct pillars: Budget Control (35 pts), Spending Pace (30 pts), Category Balance (20 pts), and Savings Momentum (15 pts)
  - forecast budget runway days and identify top spending category leak
  - report status tiers (Healthy, Moderate, Caution, Critical) and give practical student advice

- Spending graph
  - ask for a date in mm/dd/yyyy format and validate it
  - group that day's expenses by category and add them up
  - draw a bar for each category with spending, and skip categories with none
  - switch the y-axis from 0-200 to 0-1000 when a category goes over 200
  - cap a bar at 1000 even if the real amount is higher
  - tests for the date parsing, the scale switch, and the empty-day message

- Savings progress
  - list the existing goals and ask for a goal number
  - draw a bar using the goal's percentage complete
  - show a milestone message once the goal crosses 0%, 25%, 50%, 75%, or
    100% saved
  - reused the goal lookup and validation already built for adding progress
  - tests for a normal goal, each milestone message, an invalid goal number,
    and no goals yet

# In Progress

None currently (all planned work items completed, tested, and shipped).

# To do

Nothing left from the original plan. All seven planned features are built.

# Notes

Achievements needed badge rules and progress tracking that felt too big for
this project, so we replaced it with Savings Progress instead: a bar that
shows how close a goal is to being finished, using data the app already
saves.
