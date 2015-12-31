module StockChecker
  class StockComparator < Comparator

    # @param [Item] old
    # @param [Item] new
    def compare(old, new)
      notifications = []

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