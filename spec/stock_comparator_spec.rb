describe StockChecker::StockComparator do
  describe '#compare' do
    context 'when stock changes from yellow to red' do
      let(:old) do
        product = StockChecker::Product.new('Product name', 'url', 'uri')
        items = []
        items << StockChecker::Item.new('G', 'Blue', '22', 'Yellow')

        product.items = items

        product
      end

      let(:new) do
        product = StockChecker::Product.new('Product name', 'url', 'uri')
        items = []
        items << StockChecker::Item.new('G', 'Blue', '22', 'Red')

        product.items = items

        product
      end

      it 'should do generate a notification' do
        expect(subject.compare(old, new)).not_to be_empty
      end
    end
  end
end