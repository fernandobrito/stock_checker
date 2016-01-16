module StockChecker

  # Takes one or more comparators and offers a method (#compare) to
  #  run all of them on 2 products. It can be stopped if a Comparator
  #  returns false on the method #continue?
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