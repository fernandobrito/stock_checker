module StockChecker
  class Notification
    attr_accessor :product, :message

    def initialize(product, message)
      @product = product
      @message = message
    end

    def to_s
      @message
    end
  end
end