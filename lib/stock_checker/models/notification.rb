module StockChecker

  # The alerts are actually hardcoded with HTML tags. OK for now, as
  #  we only have HTML generated reports, but it should be changed in the
  #  future to allow other kind of reports.
  #
  # A notification has a message and it points to the product that generated it.
  #  This is used in the report to group notifications from the same product.
  #
  # Notifications can be ordered by priority, descending. Useful for putting
  #  removed products on top of the list.
  class Notification
    attr_accessor :product, :message, :priority

    # @param [Product] product product that generated the message
    # @param [String] message the message itself
    def initialize(product, message, priority = 0)
      @product = product
      @message = message
      @priority = priority
    end

    def to_s
      @message
    end
  end
end