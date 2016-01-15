module StockChecker

  # A product. It has a name, url, uri, items and
  #  picture_url
  class Product
    attr_accessor :items, :picture_url
    attr_reader :name, :uri, :url

    def initialize(name, uri, url)
      @name = name
      @uri = uri
      @url = url
    end

    # The main identifier of a Product is its URL (given as input)
    # If the product does not exist on the website, the parser is not
    #  able to parse its name. That is how we check if the product
    #  is available on the website or not.
    # @return [Boolean] whether this product exists or not on the website
    def exists?
      !name.nil?
    end

    # Check if this product has an item.
    # Useful for comparing old and new version of the same product
    #  and check if item still exists (when item is out of stock,
    #  it gets removed)
    # @param [Item] item
    # @return [Item]
    def find_item(item)
      return nil if @items.nil?

      result = @items.select{ |i| i.same_as?(item) }

      if result.empty?
        return nil
      else
        return result.first
      end
    end
  end
end