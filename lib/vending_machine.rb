class VendingMachine

  DEFAULT_INVENTORY = { 'chocolate' => [20, 200], 'soda' => [10, 100], 'crisps' => [15, 150] }
  DEFAULT_COIN_BANK = {'1p' => 1000, '2p' => 500, '5p' => 200, '10p' => 100, '50p' => 50, '£1' => 25, '£2' => 10}
  MONEY_MAP = { '1p' => 1, '2p' => 2, '5p' => 5, '10p' => 10, '20p' => 20, '50p' => 50, '£1' => 100, '£2' => 200, '£5' => 500, '£10' => 1000 }

  attr_reader :inventory, :coin_bank

  def initialize(inventory: DEFAULT_INVENTORY, coins: DEFAULT_COIN_BANK)
    @inventory, @initial_inventory = dup(inventory), dup(inventory)
    @coin_bank, @initial_coin_bank = dup(coins), dup(coins)
  end

  def main_menu
    puts "Please select an option:"
    puts "1 - Buy an item."
    puts "2 - Maintain the vending machine."
    puts "3 - Exit."
    main_menu_selection
  end

  def main_menu_selection
    case gets.chomp
    when 1
      customer_menu
    when 2
      manager_menu
    when 3
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
    puts "You can pay with the following coins/notes: 1p, 2p, 5p, 10p, 50p, £1, £2, £5, £10"
    puts "What would you like to insert?"
    pay_for(item)
  end

  def customer_menu_selection
    item = select_item
    while item.blank?
      puts "Sorry, that item is not available. Please select an item from the list."
      item = select_item
      return vending_machine if item == back
    end
    return item
  end

  def select_item
    item = gets.chomp
    p @inventory[item]
    return "" unless item_available?(item)
    return item
  end

  def item_available?(item)
    return false unless @inventory.include? item.chomp
    return false unless @inventory[item.chomp][0] > 0
    return true
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
    puts "You owe #{ - change_due }, how much would you like to insert?"
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

  def process_change(item, change_due, change_denominations)
    if change_denominations == {}
      puts "Sorry, I don't have change for that amount. Please try again using smaller denominations."
      return - @inventory[item][1]
    else
      complete_sale_with_change(item, change_due, change_denominations)
      return 0
    end
  end

  def complete_sale_with_change(item, change_due, change_denominations)
    complete_sale(item)
    puts "Here is your £#{ change_due / 100 } change:"
    puts change_denominations
  end

  def calculate_change(change_due)
    change = {}
    amount_due = change_due
    highest_denomination = ""
    virtual_coin_bank = dup(@coin_bank)
    while amount_due > 0
      virtual_coin_bank.each do |key, value|
        highest_denomination = key if MONEY_MAP[key] <= change_due && value > 0
      end
      unless highest_denomination == ""
        change[highest_denomination] += 1 if change[highest_denomination]
        change[highest_denomination] = 1 unless change[highest_denomination]
        virtual_coin_bank[highest_denomination] -= 1
        amount_due -= MONEY_MAP[highest_denomination]
        highest_denomination = ""
      else
        change = {}
        virtual_coin_bank = @coin_bank
        break
      end
    end
    @coin_bank = virtual_coin_bank.dup
    return change
  end

  def reload_inventory
    @inventory = dup(@initial_inventory)
  end

  def reload_coins
    @coin_bank = dup(@initial_coin_bank)
  end

  def dup(hash)
    Marshal.load(Marshal.dump(hash))
  end

end
