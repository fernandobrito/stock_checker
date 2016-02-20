describe StockChecker::Report do
  describe '.new' do
    subject do
      product1 = StockChecker::Product.new('Product', nil, nil)
      product2 = StockChecker::Product.new('Important Product', nil, nil)

      notifications = []
      notifications << StockChecker::Notification.new(product1, nil, 1)
      notifications << StockChecker::Notification.new(product1, nil, 2)
      notifications << StockChecker::Notification.new(product2, nil, 30)

      StockChecker::Report.new(notifications)
    end

    it 'should order notifications by priority' do
      expect(subject.grouped_notifications.first.first.name).to be_eql('Important Product')
    end
  end
end