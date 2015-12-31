module StockChecker

  # Product item
  class Item
    attr_reader :size, :color, :price, :stock

    # @param [String] size
    # @param [String] color
    # @param [String] price
    # @param [String] stock
    def initialize(size, color, price, stock)
      @size = size
      @color = color
      @price = price
      @stock = stock
    end

    def same_as?(item)
      return (self.size == item.size && self.color == item.color)
    end

    def to_s
      "#{@color} / #{@size}"
    end
  end
end