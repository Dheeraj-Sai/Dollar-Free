# Planning Notes

Team: Purna Vasanth Repalle and Dheeraj Sai Madhalam

## What we are building

Dollar Free, a terminal app for tracking expenses. Aimed at students who want
something simple to record what they spend.

## Essential

- main menu
- add an expense
- view the expenses
- handle bad input properly

## Optional

- daily report
- financial health
- spending graph
- savings goal
- achievements

The daily report, savings goals, and financial health ended up getting done
even though we listed them as optional.

## How we work

Split the work into small stories, one branch per feature. One person types
while the other reads along and checks the design. Run the tests and update
the story and backlog before merging.

## Done means

- the feature works from the terminal
- both good and bad input have been tested
- the tests pass
- the story and backlog are updated
- the commit message says what changed

## Update - 28 Sep 2026

Spending graph and financial health shipped as planned. We dropped
Achievements partway through, because it needed badge rules and progress
tracking that felt too big for this project, and replaced it with Savings
Progress: a bar that shows how close a goal is to done using data the app
already saves. Every feature on the original list, essential and optional,
ended up built.
