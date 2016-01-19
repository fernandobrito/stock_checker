describe StockChecker::StockComparator do
  describe '#compare' do
    let(:old) do
      product = StockChecker::Product.new('Product name', 'url', 'uri')
      product.items = [ StockChecker::Item.new('G', 'Blue', '22', 'Yellow') ]

      product
    end

    let(:new) do
      product = StockChecker::Product.new('Product name', 'url', 'uri')
      product.items = [ StockChecker::Item.new('G', 'Blue', '22', 'Red') ]

      product
    end

    context 'when stock changes from yellow to red' do
      it 'should generate a notification' do
        expect(subject.compare(old, new).size).to be_eql(1)
      end
    end

    context 'when a new item is added' do
      it 'should generate a notification' do
        old.items = []
        expect(subject.compare(old, new).size).to be_eql(1)
      end
    end

    context 'when a new item is removed' do
      it 'should generate a notification' do
        new.items = []
        expect(subject.compare(old, new).size).to be_eql(1)
      end
    end
  end
end