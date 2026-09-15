# Dollar Free

Dollar Free is a small Ruby terminal project for keeping track of expenses.
The main idea is that a user can enter expenses and later use the app to see
how they are spending money.

## What is done so far

Right now, the app has a main menu and the Add Expense feature.

- The main menu is shown when the program starts.
- Option 1 lets the user add an expense.
- The amount has to be a number bigger than 0.
- The category has to be one of the categories in the program.
- If the user enters a wrong menu number, the app shows an error message.

The other menu options are there already, but they are not built yet. They
will say that the feature is not available yet.

## How to run it

Make sure Ruby is installed first:

```bash
ruby --version
```

Go inside the project folder:

```bash
cd /Users/dheeraj/Documents/MCS/SWE/projects/Dollar-Free
```

Then start the program:

```bash
./bin/dollar_free
```

If that does not work because of permissions, run this once:

```bash
chmod +x bin/dollar_free
```

Then run `./bin/dollar_free` again.

## Main menu

When the app starts, this is the menu:

```text
====== Dollar Free ======
1. Add Expense
2. View Expenses
3. Daily Report
4. Financial Health
5. Spending Graph
6. Savings Goal
7. Achievements
8. Exit
```

Type a number and press Enter. For now, `1` and `8` are the useful options.

## Adding an expense

Choose option `1`. The program asks for the expense type and amount.

Example:

```text
Choose an option: 1
Add Expense
Expense type: Food
Amount: 15.50
Expense added successfully!
```

These are the categories that can be used:

- Food
- Transport
- Housing
- Utilities
- Health
- Education
- Entertainment
- Other

The amount must be greater than zero. For example, `0`, `-10`, or `ten` are
not accepted. Expenses are only saved while the program is open at the moment.

## Tests

The tests use Minitest, which comes with Ruby. Run them from the project
folder using:

```bash
ruby -Ilib:test -e 'Dir["test/test_*.rb"].sort.each { |file| require_relative file }'
```

## Files in the project

```text
bin/dollar_free          starts the program
lib/expense.rb           stores one expense
lib/expense_manager.rb   checks and adds expenses
lib/main_menu.rb         shows the main menu
test/                    tests for the code
user_stories_add_expense.txt  user stories and acceptance criteria
```

## Features to add later

- View expenses
- Daily report
- Financial health
- Spending graph
- Savings goal
- Achievements

## License

See the [LICENSE](LICENSE) file.
