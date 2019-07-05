class VendingMachine

  DEFAULT_INVENTORY = {'chocolate' => [20, 2], 'soda' => [10, 1], 'crisps' => [15, 1.5]}

  attr_reader :inventory

  def initialize
    @inventory = DEFAULT_INVENTORY
  end

  def select_item()
    print "What would you like to purchase"
    item = gets
    raise "Sorry, that item is not available. Please select an item from the list." unless @inventory.include? item
  end

  def pay_for(item)
    print "How much money would you like to insert? "
    inserted_amount = gets
    if inserted_amount >= @inventory[item][1]
      @inventory[item][0] -= 1
    end
  end

end
