module StockChecker

  # Compare two products. Generate alerts if the product did not exist but now it does,
  #  or vice-versa.
  class ProductComparator < Comparator
    def compare(old, new)
      # It existed, and it still does
      if (old.exists?) && (new.exists?)
        Logging::logger.info '== [ProductComparator] Product existed, and still exists'

        return []

        # It did not exist, but now it does
      elsif (! old.exists?) && (new.exists?)
        Logging::logger.info '== [ProductComparator] Product did not exist, but now it does'

        @continue = false
        return [ Notification.new(new, 'Product readded') ]

      # It existed, but now it does not
      elsif (old.exists?) && (! new.exists?)
        Logging::logger.info '== [ProductComparator] Product existed, but now it does not'

        @continue = false
        return [ Notification.new(new, 'Product removed') ]

      # Product did not exist, and still does not
      elsif (! old.exists?) && (! new.exists?)
        Logging::logger.info '== [ProductComparator] Product did not exist and still does not'

        @continue = false
        return []
      end
    end
  end
end