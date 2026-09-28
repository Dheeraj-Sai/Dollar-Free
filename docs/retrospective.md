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
- Writing tests as we went. Coverage stayed high the whole project.
- Reusing the goal lookup and validation we had already written for Savings
  Goal when we built Savings Progress. Almost no new code was needed.
- Deciding early that the Spending Graph and Savings Progress bars would
  share the same filled-bar character. It made the two features feel like
  one consistent app instead of two different styles bolted together.

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
- Picking a y-axis scale for the Spending Graph that worked for both a
  normal day and a day with one big expense. We ended up switching the
  scale instead of using a single fixed range.
- Deciding between plain ASCII characters and Unicode block characters for
  the bars. We picked the block characters for how they look, but it is a
  small risk if the grader's terminal cannot render them.

## Next time

- Update the story, backlog and design notes in the same commit as the code.
- Pull main into the branch earlier so there is less to merge.
- Let errors show instead of hiding them.
- Decide where the data is saved before writing a feature's tests.
- Spread the work over more days.
- Decide on a feature's scope before naming it on the menu. Achievements
  sounded simple until we thought through what it would actually take to
  build.

## Did we meet the goal

Yes. A user can add an expense, see everything recorded, get a report of
today's spending, set a budget and see their financial health, set savings
goals and track progress toward them with a bar, and see a spending graph
broken down by category for any day. Everything is still there after closing
the app, and bad input gets a clear message instead of a crash.

We did drop Achievements from the plan. It needed badge rules and progress
tracking that felt too big for this project, so we replaced it with Savings
Progress, a simpler feature that reuses data the app already tracks.
