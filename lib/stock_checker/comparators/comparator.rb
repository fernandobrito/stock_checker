module StockChecker

  # Class to compare two products
  class Comparator
    def initialize
      @continue = true
    end

    # Compare two products
    # @param [Item] old old product
    # @param [Item] new new product
    # @return [Array<Notification>] an array of notifications generated
    def compare(old, new)
      raise 'Method not implemented'
    end

    # Some comparators may wish to cancel the execution of future comparators.
    # This makes relevant the order in which you apply the comparators.
    # An example of when to stop is: if the product did not exist before (and had no items)
    #  but now it does, we do not want StockComparator to generate notifications
    #  for each of the items. One notification from ProductComparator is enough.
    # @return [Boolean] whether to continue next comparators
    def continue?
      @continue
    end
  end
end