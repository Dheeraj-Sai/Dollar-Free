# Retrospective

This is what the team thought after finishing the main features of Dollar Free.

## What went well

- We worked on one small feature at a time, and each one was built on its own
  branch. This meant the main branch always had a version of the app that ran.
- We passed the input and the output into the classes instead of reading and
  printing directly. Because of this, the tests could give the app fake input
  and read the output, so we never had to type anything by hand to test it.
- We kept `MainMenu`, `ExpenseManager`, and `Expense` as three separate
  classes. When we added View Expenses and the Daily Report, the menu only
  needed one new line for each of them.
- We wrote tests as we went instead of at the end. We finished with 28 tests
  that cover 100% of the code.

## What was difficult

- Saving the expenses in a file instead of keeping them in a list sounded easy,
  but it broke the tests. Every test was using the same real file, so one test
  could change what another test saw. We fixed this by giving the tests a
  temporary file to use.
- Both of us had changed the same files on different branches, so joining the
  branches together caused conflicts. We had to go through the menu, the
  expense manager, the tests, and the README and decide which version to keep.
- At one point the code caught too many errors while reading the saved file.
  If the file was damaged, the app just showed an empty list instead of saying
  something was wrong, and the next expense would have replaced everything.
- We kept changing the code without changing the documents. The README, the
  backlog, and the design notes were all out of date for a while.

## What we would improve next time

- Change the story, the backlog, and the design notes in the same commit as the
  code, so they never fall behind.
- Bring the main branch into a feature branch early, so there is less to fix
  when the branches are joined.
- Decide where the data will be saved before writing the tests for a feature,
  because that changes how the tests are set up.
- Spread the work over more days so the commit history shows steady progress.

## Did the final app meet the original goal?

Mostly yes. A user can add an expense, see all the expenses they have recorded,
and see a report of what they spent today. The expenses are still there after
closing and reopening the app. If the user types something wrong, the app
explains the problem instead of crashing.
We did not build the optional features: Financial Health, Spending Graph,
Savings Goal, and Achievements. Those options are still on the menu, and they
tell the user that the feature is not available yet.
