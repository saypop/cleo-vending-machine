class VendingMachine

  DEFAULT_INVENTORY = {'chocolate' => [20, 2], 'soda' => [10, 1], 'crisps' => [15, 1.5]}

  attr_reader :inventory

  def initialize(inventory = DEFAULT_INVENTORY)
    @inventory = inventory
  end

  def select_item()
    print "What would you like to purchase"
    item = gets
    raise "Sorry, that item is not available. Please select an item from the list." unless @inventory.include? item
  end

  def pay_for(item)
    print "How much money would you like to insert? "
    change_due = - @inventory[item][1]
    while change_due < 0
      inserted_amount = gets
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
