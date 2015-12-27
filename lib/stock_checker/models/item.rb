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

    def same_as?(item)
      return (self.size == item.size && self.color == item.color)
    end
  end
end