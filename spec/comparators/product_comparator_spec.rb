describe StockChecker::ProductComparator do
  let(:existing_product) { StockChecker::Product.new('T-Shirt', 'URL', 'URI') }
  let(:missing_product) { StockChecker::Product.new(nil, 'URL', 'URI') }

  describe '#compare' do
    context 'when product existed, and still exists' do
      it 'generates no alert' do
        expect(subject.compare(existing_product, existing_product)).to be_empty
      end
    end

    context 'when product did not exist, but now it does' do
      it 'generates an alert' do
        expect(subject.compare(missing_product, existing_product)).not_to be_empty
      end
    end

    context 'when product existed, but now it does not' do
      it 'generates an alert' do
        expect(subject.compare(existing_product, missing_product)).not_to be_empty
      end
    end

    context 'when product existed, and still exists' do
      it 'generates no alert' do
        expect(subject.compare(missing_product, missing_product)).to be_empty
      end
    end
  end
end