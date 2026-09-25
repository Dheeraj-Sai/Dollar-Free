# Pairing Log

Team: Purna Vasanth Repalle and Dheeraj Sai Madhalam

## Session 1 - 14 Sep 2026

Driver: Dheeraj
Navigator: Vasanth

- set up bin, lib and test folders
- built the main menu and the 8 options
- built Add Expense with the Expense and ExpenseManager classes
- added the checks for category and amount

We decided to pass input and output into the classes instead of printing
directly, so the tests could run without anyone typing. Also picked BigDecimal
for the amounts because money should not drift.

## Session 2 - 14 Sep 2026

Driver: Dheeraj
Navigator: Vasanth

- wrote the user stories, design and planning notes
- added the acceptance tests that run the whole app from the menu
- added the coverage report

Agreed that a story is not done until the tests pass and the documents are
updated in the same change.

## Session 3 - 14 Sep 2026

Driver: Vasanth
Navigator: Dheeraj

- built View Expenses and the Daily Report
- moved from keeping expenses in a list to saving them in JSON
- gave ExpenseManager a file path setting so tests use a temp file

Argued a bit about whether View Expenses should read the file directly. Went
with reading the array so there is only one answer while the app is running.

Also found that catching too many errors when reading the file was risky. A
broken file looked like an empty list and the next expense would have wiped
the real ones. Changed it to stop with an error instead.

## Session 4 - 15 Sep 2026

Driver: Vasanth
Navigator: Dheeraj

- joined the two branches and fixed the conflicts
- updated the stories, backlog, design notes and README to match the app
- wrote the retrospective

The conflicts happened because we both changed the same files at the same
time. Next time we pull main into our branch earlier. We kept the amount check
from main since it gave a clearer message for something like "5.".

## Session 5 - 25 Sep 2026

Driver: Dheeraj
Navigator: Vasanth

- built Savings Goals submenu with goal creation, daily amount calculation, and goal listing
- added savings progress tracking to record saved amounts, remaining amounts, and completion percentage
- added JSON persistence for savings goals in data/savings_goals.json
- fixed submenu navigation to return to the main menu on blank input
- added comprehensive unit, manager, and end-to-end integration tests
- updated documentation, user stories, backlog, design notes, and pairing log

## Session 6 - 25 Sep 2026

Driver: Dheeraj
Navigator: Vasanth

- built Financial Health feature (FT05) with user budget setup and updating
- integrated FinancialHealthManager with ExpenseManager to compute remaining budget and spent percentage
- implemented 0-100 financial health score and status advice tiers
- added JSON persistence for the budget in data/budget.json
- wrote unit tests, manager tests, and end-to-end acceptance tests
- updated documentation, user stories, backlog, design notes, and pairing log


