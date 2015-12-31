describe StockChecker::Product do
  describe '#find_item' do
    subject do
      product = StockChecker::Product.new('Product name', 'url', 'uri')
      items = []
      items << StockChecker::Item.new('G', 'Blue', '12.2', 'Green')

      product.items = items

      product
    end

    context 'when item exists' do
      let(:item) { StockChecker::Item.new('G', 'Blue', '13.4', 'Blue')}

      it 'finds the item' do
        expect(subject.find_item(item)).not_to be_nil
      end
    end

    context 'when item does not exist' do
      let(:item) { StockChecker::Item.new('G', 'Red', '13.4', 'Green')}

      it 'finds not the item' do
        expect(subject.find_item(item)).to be_nil
      end
    end
  end
end