module StockChecker
  class BatchComparator
    attr_accessor :comparators, :notifications

    def initialize
      @comparators = Array.new
      @notifications = Array.new
    end

    def compare(old, new)
      for comparator_class in @comparators
        comparator = comparator_class.new

        @notifications += comparator.compare(old, new)

        break unless comparator.continue?
      end
    end
  end
 end