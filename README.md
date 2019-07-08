# cleo-vending-machine

#### To run this program:
- change to the 'cleo-vending-machine' directory in your terminal;
- `ruby run.rb`

#### Then to run tests:
- `rspec`

#### The challenge was to design a vending machine that behaves as follows:
- Once an item is selected and the appropriate amount of money is inserted, the vending machine should return the correct product;
- It should also return change if too much money is provided, or ask for more money if insufficient funds have been inserted;
- The machine should take an initial load of products and change. The change will be of denominations 1p, 2p, 5p, 10p, 20p, 50p, £1, £2;
- There should be a way of reloading either products or change at a later point; and
- The machine should keep track of the products and change that it contains.

#### The solution needs to:
- Be written in ruby
- Have tests
- Include a readme - think of it like the description you write on a github PR. Consider: explaining any decisions you made, telling us how to run it if it’s not obvious, signposting the best entry point for reviewing it, etc...

#### Features:
My solution does the following:
- Let's a user select an item;
- Let's a user pay for an item;
- Gives the user an item if they pay exact money for an item and removes the item from the inventory;
- Gives the user an item and change if they pay more than required and removes the item from the inventory;
- Doesn't give the user an item or remove it from inventory if the item is unavailable or if change cannot be made;
- Asks the user for more money if not enough was provided;
- The vending machine loads with a default set of items and a default coin bank;
- The default sets of items and coin bank can be overridden;
- Product and coins can be reloaded;
- Both the inventory of items and coin bank can be viewed;
- Money inserted is checked if it is the correct denomination.


#### A overview of my process can be seen in my commit history:
1. first commit
2. created folder structure
3. Test #1 passing: - is initialized with a default inventory if none is provided
4. Test #2 passing: - lets a customer select an item that is in the inventory
5. Test #3 passing: - does not allow a customer to select an item that is not in the inventory
6. Test #4 passing: - removes an item from inventory when full payment is received
7. Test #5 passing: - removes an item from inventory when full payment is receive in increments
8. Test #6 passing: - takes an initial load of products
9. Test #7 passing: - takes an initial load of coins
10. Test #8 passing: - removes the change in the highest denomination available
11. Test #9 passing: - returns the change in the highest denomination available
12. Test #10 passing: - returns an empty hash when change cannot be made
13. Test #11 passing: - does not alter coin bank when change cannot be made
14. Test #12 passing: - does not remove an item if change cannot be made
15. Test #13 passing: - tops up inventory to the levels that were originally loaded
16. Test #14 passing: - tops up coins to the levels that were originally loaded
17. UX and refactoring #1: - added main menu - added customer menu - added ability to select item - refactored select_item method
18. UX and refactoring #2: - Refactored pay_for method - Extracted: validate_money, abort_transaction, request_payment, assess_transaction, complete_sale, process_change and complete_sale_with_change methods.
19. Test #15 passing: - does not allow a customer to select an item that is out of stock
20. UX and refactoring #3: - refactored calculate change method - extracted get_highest_denominations, get_highest_denominations, update_bank, reset_change methods
21. UX and refactoring #4: - added manager menu - created run file
22. Config #1: - blocked printing when running tests - updated readme
23. UX and refactoring #5: - added clearer instructions for loading new inventories and coin banks.

#### Notes:
I'm happy with this solution - it meets all acceptance criteria, I like the UX works, and I like that most edge cases are covered. I also think it's efficient algorithmically, there are no nested loops, and all algorithms have a single output.
If I were to put more time into it I would extract the single vending machine class into separate inventory, coin bank, and interface classes.
I'd also update the way inputted coins are managed, if a coin bank is missing some coins that are inserted it would be good if those coins were added to the coin bank.
