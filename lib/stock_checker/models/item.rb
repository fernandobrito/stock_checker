module StockChecker

  # Product item
  class Item
    attr_reader :size, :color, :price, :stock

    def initialize(size, color, price, stock)
      @size = size
      @color = color
      @price = price
      @stock = stock
    end
  end
end