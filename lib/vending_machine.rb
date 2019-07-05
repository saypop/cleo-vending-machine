class VendingMachine

  DEFAULT_INVENTORY = {'chocolate' => [20, 2], 'soda' => [10, 1], 'crisps' => [15, 1.5]}

  attr_reader :inventory

  def initialize
    @inventory = DEFAULT_INVENTORY
  end

  def select_item(item)
    raise "Sorry, that item is not available. Please select an item from the list." unless @inventory.include? item
  end

end
