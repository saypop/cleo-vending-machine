require 'vending_machine'

describe VendingMachine do

  it 'is initialized with a default inventory if none is provided' do
    expect(described_class.new.inventory).to eq({'chocolate' => [20, 2], 'soda' => [10, 1], 'crisps' => [15, 1.5]})
  end

end
