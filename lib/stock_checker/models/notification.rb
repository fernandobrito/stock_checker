module StockChecker

  # The alerts are actually hardcoded with HTML tags. OK for now, as
  #  we only have HTML generated reports, but it should be changed in the
  #  future to allow other kind of reports.
  #
  # A notification has a message and it points to the product that generated it.
  #  This is used in the report to group notifications from the same product.
  class Notification
    attr_accessor :product, :message

    # @param [Product] product product that generated the message
    # @param [String] message the message itself
    def initialize(product, message)
      @product = product
      @message = message
    end

    def to_s
      @message
    end
  end
end