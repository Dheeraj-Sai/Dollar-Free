# Pairing Log

This file records the pair-programming sessions for Dollar Free. The team is
Purna Vasanth Repalle and Dheeraj Sai Madhalam.

## Session 1 — 2026-09-14

Driver: Dheeraj Sai Madhalam
Navigator: Purna Vasanth Repalle

Work completed:

- Set up the project folders: `bin`, `lib`, and `test`.
- Built the main menu and the eight options.
- Built Add Expense with the `Expense` and `ExpenseManager` classes.
- Added the checks for the category and the amount.

Notes:

- We decided to pass the input and the output into the classes instead of
  printing directly. This was so the tests could give fake input and read the
  output without a person typing anything.
- We chose `BigDecimal` for the amount instead of a normal decimal number,
  because money needs to stay exact.

## Session 2 — 2026-09-14

Driver: Dheeraj Sai Madhalam
Navigator: Purna Vasanth Repalle

Work completed:

- Wrote the user stories and the design and planning notes.
- Added the acceptance tests that run the whole app from the menu.
- Added the coverage report.

Notes:

- We agreed that a story is only done when the tests pass and the documents
  have been updated in the same change.

## Session 3 — 2026-09-14

Driver: Purna Vasanth Repalle
Navigator: Dheeraj Sai Madhalam

Work completed:

- Built View Expenses and the Daily Report.
- Changed the app to save expenses in `data/expenses.json` instead of losing
  them when the app closed.
- Gave `ExpenseManager` a file path setting, so the tests use a temporary file.

Notes:

- We talked about whether View Expenses should read the file directly. We
  decided it should read the array instead, so there is only one answer to
  "what are my expenses" while the app is running.
- We found that catching too many errors while reading the file was dangerous.
  A damaged file looked like an empty list, and the next expense would have
  replaced the real records. We changed it to stop with an error.

## Session 4 — 2026-09-15

Driver: Purna Vasanth Repalle
Navigator: Dheeraj Sai Madhalam

Work completed:

- Joined the two branches together and fixed the conflicts in the menu, the
  expense manager, the tests, and the README.
- Updated the user stories, the backlog, the design notes, and the README so
  they matched the working app.
- Wrote the retrospective.

Notes:

- The conflicts were caused by both of us changing the same files at the same
  time. Next time we will bring the main branch into our own branch earlier.
- We kept the version of the amount check from the main branch, because it
  gave a clearer message when someone typed something like "5.".
