class VendingMachine

  DEFAULT_INVENTORY = { 'chocolate' => [20, 200], 'soda' => [10, 100], 'crisps' => [15, 150] }
  DEFAULT_COINAGE = {'1p' => 1000, '2p' => 500, '5p' => 200, '10p' => 100, '50p' => 50, '£1' => 25, '£2' => 10}
  COIN_MAP = { '1p' => 1, '2p' => 2, '5p' => 5, '10p' => 10, '50p' => 50, '£1' => 100, '£2' => 200 }

  attr_reader :inventory, :coins

  def initialize(inventory: DEFAULT_INVENTORY, coins: DEFAULT_COINAGE)
    @inventory, @initial_inventory = inventory
    @coins, @inital_coinage = coins
  end

  def select_item()
    print "What would you like to purchase"
    item = gets
    raise "Sorry, that item is not available. Please select an item from the list." unless @inventory.include? item
  end

  def pay_for(item)
    puts "You can pay with the following coins: 1p, 2p, 5p, 10p, 50p, £1, £2"
    print "Which coin would you like to insert? "
    change_due = - @inventory[item][1]
    while change_due < 0
      inserted_coin = gets
      inserted_amount = COIN_MAP[inserted_coin.chomp]
      change_due += inserted_amount
      if change_due >= 0
        @inventory[item][0] -= 1
        puts "Thanks, here's your #{item}!"
        puts "Here is your change: #{change_due}" unless change_due == 0
      else
        print "You still owe #{- change_due}, how much would you like to insert?"
      end
    end
  end

end
