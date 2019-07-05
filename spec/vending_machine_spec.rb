require 'vending_machine'

describe VendingMachine do

  it 'is initialized with a default inventory if none is provided' do
    vending_machine = described_class.new
    expect(vending_machine.inventory).to eq({'chocolate' => [20, 2], 'soda' => [10, 1], 'crisps' => [15, 1.5]})
  end

  describe '#select_item' do

    it 'lets a customer select an item that is in the inventory' do
      vending_machine = described_class.new
      allow_any_instance_of(Kernel).to receive(:gets).and_return('chocolate')
      expect{ vending_machine.select_item }.not_to raise_error
    end

    it 'does not allow a customer to select an item that is not in the inventory' do
      vending_machine = described_class.new
      allow_any_instance_of(Kernel).to receive(:gets).and_return('gold watch')
      expect{ vending_machine.select_item }.to raise_error("Sorry, that item is not available. Please select an item from the list.")
    end

  end

  describe '#pay_for' do

    it 'removes an item from inventory when full payment is received in full' do
      vending_machine = described_class.new
      allow_any_instance_of(Kernel).to receive(:gets).and_return(2)
      expect { vending_machine.pay_for("chocolate") }.to change{ vending_machine.inventory['chocolate'][0] }.from(20).to(19)
    end

    it 'removes an item from inventory when full payment is receive in increments' do
      vending_machine = described_class.new
      allow_any_instance_of(Kernel).to receive(:gets).and_return(1)
      expect { vending_machine.pay_for("crisps") }.to change{ vending_machine.inventory['crisps'][0] }.from(15).to(14)
    end

  end

  it 'takes an initial load of products' do
    vending_machine = described_class.new({'haribo' => [20, 2], 'water' => [10, 1], 'mints' => [15, 1.5]})
    expect(vending_machine.inventory).to eq({'haribo' => [20, 2], 'water' => [10, 1], 'mints' => [15, 1.5]})
  end

end
