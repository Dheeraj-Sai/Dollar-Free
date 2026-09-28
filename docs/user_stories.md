# User Stories

This file lists the stories for Dollar Free. Stories marked **Done** are in the
current version of the program. The rest are planned for later work.

## 1. Main menu — Done (Essential)

As a user, I want to see a main menu when I open Dollar Free so that I can
choose what I want to do.

Acceptance criteria:

- The program displays options 1 through 8 when it starts.
- Option 1 opens Add Expense.
- Option 8 closes the program.
- A wrong option shows an error and returns to the menu.

## 2. Add an expense — Done (Essential)

As a user, I want to add an expense category and amount so that I can track
what I spend.

Acceptance criteria:

- The program asks for a category and amount.
- A valid expense is added and a success message is shown.
- The expense is saved to a file, so it is still there the next time the
  program is opened.

## 3. Invalid expense input — Done (Essential / Sad Path)

As a user, I want to get a useful message when my expense input is wrong so
that I know how to fix it.

Acceptance criteria:

- Zero and negative amounts are rejected.
- Text instead of an amount is rejected.
- Missing or unsupported categories are rejected.
- The program does not crash after invalid input.

## 4. View expenses — Done (Essential)

As a user, I want to view the expenses I have entered so that I can review my
spending.

Acceptance criteria:

- Choosing option 2 shows all the expenses that have been recorded.
- The list also includes expenses added the last time the program was open.
- Each expense is numbered and shows its date, category, and amount.
- A clear message is shown if there are no expenses yet.

## 5. Daily report — Done (Essential)

As a user, I want to see a daily total so that I know how much I spent today.

Acceptance criteria:

- Choosing option 3 shows the report, and the heading says which day it covers.
- Only the expenses from that day are listed. Expenses from other days are
  left out.
- The report shows the total spent that day.
- A clear message is shown if nothing was spent that day.

## 6. Savings goal — Done

As a student, I want to set savings goals so that I know how much I need to
save each day to reach my targets.

Acceptance criteria:

- Choosing option 6 opens the Savings Goal submenu.
- I can enter a target amount and a whole number of days.
- The app shows the daily amount I need to save, rounded up to the nearest
  cent.
- I can add and view more than one goal.
- I can manually add savings progress to a selected goal.
- Each goal shows the amount saved, remaining amount, and percentage complete.
- Goals and their progress are saved and loaded when the app restarts.
- Invalid goal amounts, days, progress amounts, goal numbers, and submenu
  choices show useful error messages.

## 7. Financial health — Done (Optional)

As a student, I want to view my financial health so that I can understand how
much money I have spent and how much I have remaining in my budget.

Acceptance criteria:

- Choosing option 4 opens the Financial Health submenu.
- I can set or update a total budget greater than zero.
- The budget is saved to a file and loaded again when the program restarts.
- If no budget has been set yet, the app prompts me to enter one.
- The report compares my budget with total expenses and displays the remaining
  budget (or exceeded amount), health score (0 to 100), status, and advice.
- The health score evaluates 4 pillars: Budget Control (35 pts), Spending Pace
  vs. safe daily allowance (30 pts), Category Balance (20 pts), and Savings
  Momentum (15 pts).
- The report forecasts budget runway days and flags top spending category leaks.
- The app indicates when I am within budget, when I have reached my exact
  budget, or when I have exceeded it.
- Invalid budget amounts (blank, text, zero, negative) show useful errors.
- I can return to the main menu from the Financial Health submenu.

## 8. Spending graph — Done (Optional)

As a user, I want to see spending by category in a terminal graph so that I
can quickly compare where my money goes on a given day.

Acceptance criteria:

- Choosing option 5 asks for a date in mm/dd/yyyy format.
- The graph draws one bar per category, labeled along the bottom.
- Categories with nothing spent on that date are left off the graph.
- The y-axis goes up to 200 by default, or up to 1000 if any category's total
  for that date is over 200.
- A single category's bar is capped at 1000 even if the real total is higher.
- A clear message is shown if nothing was spent on the chosen date.
- A blank or badly formatted date shows a useful error message.

## 9. Expenses are kept after closing the app — Done (Essential)

As a user, I want my expenses to still be there when I reopen Dollar Free so
that I do not lose my records every time I close it.

Acceptance criteria:

- An expense is saved to a file as soon as it is added.
- The saved expenses are loaded again when the program starts.
- The first time the program runs, when there is no saved file yet, it starts
  with an empty list and does not show an error.
- An expense that was rejected is not saved.

## 10. Savings progress — Done (Optional)

As a student, I want to see a progress bar for a savings goal so that I can
tell at a glance how close I am to reaching it.

Acceptance criteria:

- Choosing option 7 lists the existing savings goals and asks for a goal
  number.
- The chosen goal's percentage complete is drawn as a filled and unfilled bar.
- A short message is shown once the goal has crossed 0%, 25%, 50%, 75%, or
  100% saved.
- A clear message is shown if no savings goals have been added yet.
- An invalid goal number shows a useful error message.
