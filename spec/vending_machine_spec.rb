require 'vending_machine'

describe VendingMachine do

  vending_machine = described_class.new

  it 'is initialized with a default inventory if none is provided' do
    expect(vending_machine.inventory).to eq({'chocolate' => [20, 2], 'soda' => [10, 1], 'crisps' => [15, 1.5]})
  end

  describe '#select_item' do

    it 'lets a customer select an item that is in the inventory' do
      allow_any_instance_of(Kernel).to receive(:gets).and_return('chocolate')
      expect{ vending_machine.select_item }.not_to raise_error
    end

    it 'does not allow a customer to select an item that is not in the inventory' do
      allow_any_instance_of(Kernel).to receive(:gets).and_return('gold watch')
      expect{ vending_machine.select_item }.to raise_error("Sorry, that item is not available. Please select an item from the list.")
    end

  end

  describe '#pay_for' do

    it 'removes an item from inventory when full payment is received' do
      allow_any_instance_of(Kernel).to receive(:gets).and_return(2)
      expect { vending_machine.pay_for("chocolate") }.to change{ vending_machine.inventory['chocolate'][0] }.from(20).to(19)
    end

  end

end
