class VendingMachine

  DEFAULT_INVENTORY = { 'chocolate' => [20, 200], 'soda' => [10, 100], 'crisps' => [15, 150] }
  DEFAULT_COIN_BANK = {'1p' => 1000, '2p' => 500, '5p' => 200, '10p' => 100, '50p' => 50, '£1' => 25, '£2' => 10}
  MONEY_MAP = { '1p' => 1, '2p' => 2, '5p' => 5, '10p' => 10, '20p' => 20, '50p' => 50, '£1' => 100, '£2' => 200, '£5' => 500, '£10' => 1000 }

  attr_reader :inventory, :coin_bank, :purchase_history

  def initialize(inventory: DEFAULT_INVENTORY, coins: DEFAULT_COIN_BANK)
    @inventory, @initial_inventory = dup(inventory), dup(inventory)
    @coin_bank, @initial_coin_bank = dup(coins), dup(coins)
    @purchase_history = { }
  end

  def main_menu
    puts "Please select an option:"
    puts "1 - Buy an item."
    puts "2 - Maintain the vending machine."
    puts "3 - Exit."
    main_menu_selection
  end

  def select_item
    item = gets.chomp
    return "" unless item_available?(item)
    return item
  end

  def pay_for(item)
    change_due = - @inventory[item][1]
    request_payment(change_due)
    while change_due < 0
      payment = validated_money
      change_due += payment unless payment == nil
      change_due = assess_transaction(item, change_due)
    end
  end

  def process_change(item, change_due, change_denominations)
    if change_denominations == {}
      puts "Sorry, I don't have change for that amount. Please try again using smaller denominations."
      return - @inventory[item][1]
    else
      complete_sale_with_change(item, change_due, change_denominations)
      return 0
    end
  end

  def calculate_change(change_due)
    change = {}
    @virtual_coin_bank = dup(@coin_bank)
    change = get_highest_denominations(change_due, change)
    @coin_bank = dup(@virtual_coin_bank)
    return change
  end

  def reload_inventory
    @inventory = dup(@initial_inventory)
    puts "Inventory reloaded to:"
    puts @inventory
  end

  def reload_coins
    @coin_bank = dup(@initial_coin_bank)
    puts "Coin bank reloaded to:"
    puts @coin_bank
  end

  def log_purchase(item)
    if @purchase_history.include? item
      @purchase_history[item] += 1
      return
    else
      @purchase_history[item] = 1
    end
  end

  def top_3_items
    @purchase_history.sort_by {|_key, value| -value}.first(3).map { |k, v| k }
  end

  private

  def main_menu_selection
    case gets.chomp
    when '1'
      customer_menu
    when '2'
      manager_menu
    when '3'
      exit
    else
      puts "That was not a valid response, please choose option 1, 2, or 3."
      main_menu_selection
    end
  end

  def customer_menu
    puts "What would you like to purchase?"
    @inventory.each { |k, v| puts "#{ k } for £#{ v[1] / 100 }" if v[0] > 0}
    puts "Or type in 'back' to go back to the main menu."
    item = customer_menu_selection
    puts "You have selected #{ item } for £#{ @inventory[item][1] / 100 }"
    pay_for(item)
    sleep 2
    main_menu
  end

  def customer_menu_selection
    item = select_item
    while blank?(item)
      puts "Sorry, that item is not available. Please select an item from the list."
      item = select_item
      return vending_machine if item == back
    end
    return item
  end

  def item_available?(item)
    return false unless @inventory.include? item.chomp
    return false unless @inventory[item.chomp][0] > 0
    return true
  end

  def validated_money
    inserted_coin = gets
    abort_transaction if inserted_coin == 'cancel'
    inserted_amount = MONEY_MAP[inserted_coin.chomp]
    puts "Sorry I can't accept that, please insert a valid denomination." if inserted_amount == nil
    return inserted_amount
  end

  def abort_transaction
    main_menu
    exit
  end

  def request_payment(change_due)
    puts "You owe £#{ - change_due / 100 }, how much would you like to insert?"
    puts "You can pay with the following coins/notes: 1p, 2p, 5p, 10p, 50p, £1, £2, £5, £10"
    puts "Or you can cancel this transaction and return to the main menu by typing cancel"
  end

  def assess_transaction(item, change_due)
    case
    when change_due < 0
      request_payment(change_due)
      return change_due
    when change_due == 0
      complete_sale(item)
      return 0
    when change_due > 0
      change_denominations = calculate_change(change_due)
      process_change(item, change_due, change_denominations)
    end
  end

  def complete_sale(item)
    @inventory[item][0] -= 1
    puts "Thanks, here's your #{ item }!"
  end

  def complete_sale_with_change(item, change_due, change_denominations)
    complete_sale(item)
    puts "Here is your £#{ change_due / 100 } change:"
    puts change_denominations
  end

  def get_highest_denominations(change_due, change)
    while change_due > 0
      highest_denomination = get_highest_denomination(change_due)
      unless highest_denomination == ""
        update_bank(highest_denomination, change)
        change_due -= MONEY_MAP[highest_denomination]
      else
        change = reset_change
        break
      end
    end
    return change
  end

  def get_highest_denomination(change_due)
    highest_denomination = ""
    @virtual_coin_bank.each do |key, value|
      highest_denomination = key if MONEY_MAP[key] <= change_due && value > 0
    end
    return highest_denomination
  end

  def update_bank(highest_denomination, change)
    change[highest_denomination] += 1 if change[highest_denomination]
    change[highest_denomination] = 1 unless change[highest_denomination]
    @virtual_coin_bank[highest_denomination] -= 1
  end

  def reset_change
    @virtual_coin_bank = dup(@coin_bank)
    return {}
  end

  def manager_menu
    puts "Please select an option:"
    puts "1 - View inventory."
    puts "2 - View coin bank."
    puts "3 - Reload inventory."
    puts "4 - Reload coin bank."
    puts "5 - Load a new set of items."
    puts "6 - Load a new set of coins."
    puts "7 - Back to main menu."
    manager_menu_selection
  end

  def manager_menu_selection
    case gets.chomp
    when '1'
      puts @inventory
    when '2'
      puts @coin_bank
    when '3'
      reload_inventory
    when '4'
      reload_coins
    when '5'
      load_inventory
    when '6'
      load_coins
    when '7'
      main_menu
    else
      puts "That was not a valid selection, please choose either 1, 2, 3, 4, 5, 6, or 7:"
    end
    sleep 2
    manager_menu
  end

  def load_inventory
    puts "Enter an inventory in hash format"
    puts "e.g. { 'chocolate' => [20, 200], 'soda' => [10, 100], 'crisps' => [15, 150] }"
    puts "Where the format of each element in the hash is: 'name' => [quantity, price_in_cents]"
    @inventory = gets.chomp
  end

  def load_coins
    puts "Enter a coin bank in hash format"
    puts "e.g. {'1p' => 1000, '2p' => 500, '5p' => 200, '10p' => 100, '50p' => 50, '£1' => 25, '£2' => 10}"
    puts "Where the format of each element in the hash is: 'denomination' => [quantity]"
    @coin_bank = gets.chomp
  end

  def dup(hash)
    Marshal.load(Marshal.dump(hash))
  end

  def blank?(string)
    string == ""
  end

end
