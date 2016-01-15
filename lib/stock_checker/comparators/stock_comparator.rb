module StockChecker

  # Compare individual items of each product. Generate alerts if the stock
  #  status (described in the website as either Green, Yellow or Red) has changed
  #  and it is now Red.
  #
  # Red means 'low' stock. If the item is out of stock, the website actually
  #  removes it from our JSON. If an item is removed or added, an alert is also generated.
  class StockComparator < Comparator
    def compare(old, new)
      notifications = []

      # Start by iterating over the products from the new item.
      # Allows us to find items added.
      for new_item in new.items
        old_item = old.find_item(new_item)

        if old_item.nil?
          Logging::logger.info '== [StockComparator] New item: ' + new_item.to_s

          notifications << Notification.new(new, "<span class='green strong'>Item added:</span> #{new_item.to_s}")
        else
          if old_item.stock != new_item.stock && new_item.stock == 'Red'
            notifications << Notification.new(new, "<span class='strong'>Stock changed:</span> #{new_item.to_s} (#{old_item.stock} -> #{new_item.stock})")
          end
        end
      end

      # We also have to iterate over items from the old product.
      # Allows us to find items deleted.
      for old_item in old.items
        new_item = new.find_item(old_item)

        if new_item.nil?
          Logging::logger.info '== [StockComparator] Item removed: ' + old_item.to_s

          notifications << Notification.new(new, "<span class='red strong'>Item removed:</span> #{old_item.to_s}")
        end
      end

      notifications
    end
  end
 end