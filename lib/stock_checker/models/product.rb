module StockChecker
  class Product
    attr_accessor :items, :picture_url
    attr_reader :name, :uri, :url

    def initialize(name, uri, url)
      @name = name
      @uri = uri
      @url = url
    end

    def exists?
      !name.nil?
    end

    # @return [Item]
    def find_item(item)
      return nil if @items.nil?

      result = @items.select{|i| i.same_as?(item) }

      if result.empty?
        return nil
      else
        return result.first
      end
    end
  end
end