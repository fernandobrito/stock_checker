module StockChecker

  # An item of a product.
  #
  # A product is, for example, a specific t-shirt.
  # Items describe specific colors and sizes, the price and
  #  the stock status, described in colors:
  #  Green: on stock. Yellow: few items left. Red: last few left
  #  When the product is out of stock, it does not appear at all
  class Item
    attr_accessor :size, :color, :price, :stock

    # @param [String] size
    # @param [String] color
    # @param [String] price
    # @param [String] stock
    def initialize(size, color, price = nil, stock = nil)
      @size = size
      @color = color
      @price = price
      @stock = stock
    end

    # Compares an item by size and color
    # @param [Item] item to be compared
    def same_as?(item)
      (self.size == item.size && self.color == item.color)
    end

    # @return [String] string representation (color / size) of item
    def to_s
      "#{@color} / #{@size}"
    end
  end
end