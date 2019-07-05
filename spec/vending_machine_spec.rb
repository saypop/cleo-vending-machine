require 'vending_machine'

describe VendingMachine do

  it 'is initialized with a default inventory if none is provided' do
    expect(described_class.new.inventory).to eq({'chocolate' => [20, 2], 'soda' => [10, 1], 'crisps' => [15, 1.5]})
  end

  describe '#select_item' do
    vending_machine = described_class.new

    it 'lets a customer select an item that is in the inventory' do
      expect(vending_machine.select_item("chocolate"))
    end

    it 'does not allow a customer to select an item that is not in the inventory' do
      expect{ vending_machine.select_item("gold watch") }.to raise_error("Sorry, that item is not available. Please select an item from the list.")
    end

  end

end
