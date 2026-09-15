# Retrospective

## What went well

- One small feature per branch, so main always had a working version.
- Passing input and output into the classes. This turned out to be the best
  early decision because the tests could feed in fake input and read the
  output without anyone typing.
- Keeping MainMenu, ExpenseManager and Expense separate. Adding View Expenses
  and the Daily Report only took one new line in the menu each.
- Picking BigDecimal at the start, so 15.50 stayed exact once we started
  saving to a file.
- Writing tests as we went. Ended at 28 tests and 100% coverage.

## What was hard

- Saving to a file sounded like a small change but it broke the tests, because
  they were all sharing one real file. Fixed by giving them a temp file.
- Joining the two branches. We had both edited the menu, the expense manager,
  the tests and the README, so there was a lot to go through by hand.
- We caught too many errors while reading the saved file at one point. A
  broken file just looked empty, and the next expense would have replaced
  everything.
- The README, backlog and design notes fell behind the code and had to be
  fixed later.

## Next time

- Update the story, backlog and design notes in the same commit as the code.
- Pull main into the branch earlier so there is less to merge.
- Let errors show instead of hiding them.
- Decide where the data is saved before writing a feature's tests.
- Spread the work over more days.

## Did we meet the goal

Mostly. A user can add an expense, see everything recorded, and get a report
of today's spending, and it is all still there after closing the app. Bad
input gets a clear message instead of a crash.

We did not build Financial Health, Spending Graph, Savings Goal or
Achievements. Those options are still on the menu and say they are not
available yet.
