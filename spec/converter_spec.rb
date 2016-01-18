describe StockChecker::Converter do
  let(:json) { eval(open_sample_file('men-tshirt-json.txt')) }
  let(:colors) { { '42706303' => 'Black', '42706301' => 'White' } }

  let(:items) do
    array = []
    array << StockChecker::Item.new('Small', 'Black', '£4.00', 'Green')
    array << StockChecker::Item.new('XX Large', 'White', '£4.00', 'Green')
  end

  describe '.convert_complex_json' do
    it 'returns an array of Item' do
      expect(subject.convert_complex_json(json, colors)).to include(*items)
    end
  end

  describe '.convert_items_to_string_rows' do
    it 'returns the product name' do
      string1 = "Black      /   Small    /   £4.00    /   Green"
      string2 = "White      /  XX Large  /   £4.00    /   Green"
      expect(subject.convert_items_to_string_rows(items)).to include(string1, string2)
    end
  end
end