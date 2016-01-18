describe StockChecker::Parser do
  subject do
    parser = StockChecker::Parser.new('http://www.sportsdirect.com/lonsdale-sleeveless-t-shirt-mens-427063')
    parser.page = open_sample_file('men-tshirt.html')

    parser
  end

  describe '#uri' do
    it 'returns the right URI' do
      expect(subject.uri).to be_eql('lonsdale-sleeveless-t-shirt-mens-427063')
    end
  end

  describe '#product_name' do
    it 'returns the product name' do
      expect(subject.product_name).to be_eql('Lonsdale Sleeveless T Shirt Mens')
    end
  end

  describe '#picture_url' do
    it 'returns the picture URL' do
      expect(subject.picture_url).to be_eql('http://images.sportsdirect.com/images/imgzoom/42/42706303_xxl.jpg')
    end
  end

  describe '#json_variants' do
    it 'returns the JSON string with items data' do
      json = eval(open_sample_file('men-tshirt-json.txt'))
      expect(subject.json_variants).to be_eql(json)
    end
  end

  describe '#colors' do
    it 'returns the colors' do
      colors = { '42706303' => 'Black', '42706301' => 'White' }
      expect(subject.colors).to be_eql(colors)
    end
  end



end