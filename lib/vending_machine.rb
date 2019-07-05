class VendingMachine

  DEFAULT_INVENTORY = {'chocolate' => [20, 2], 'soda' => [10, 1], 'crisps' => [15, 1.5]}

  attr_reader :inventory

  def initialize
    @inventory = DEFAULT_INVENTORY
  end

  def select_item(item)

  end

end
