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

## 6. Savings goal — To Do

As a user, I want to set a savings goal so that I can work toward saving money.

Acceptance criteria:

- I can enter a goal amount greater than zero.
- The program shows whether my spending is within the goal.

## 7. Spending graph — To Do (Optional)

As a user, I want to see spending by category in a terminal graph so that I
can quickly compare where my money goes.

Acceptance criteria:

- The graph uses the expenses in the current session.
- Each category has a readable label and value.

## 8. Expenses are kept after closing the app — Done (Essential)

As a user, I want my expenses to still be there when I reopen Dollar Free so
that I do not lose my records every time I close it.

Acceptance criteria:

- An expense is saved to a file as soon as it is added.
- The saved expenses are loaded again when the program starts.
- The first time the program runs, when there is no saved file yet, it starts
  with an empty list and does not show an error.
- An expense that was rejected is not saved.
