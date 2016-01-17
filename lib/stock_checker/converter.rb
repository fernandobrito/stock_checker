module StockChecker

  # Module to convert the original JSON from the website to an array
  #  of items
  #
  # JSON Structure:
  # Array with color ColVarId:
  #  SizeVariants field with array:
  #    SizeName
  #    ProdSizePrices
  #      SellPrice
  module Converter

    # Converts an entire hashed JSON with all product items (from the website)
    #  to an array of Item objects
    # On the process, replaces color_ids with the color name (which is stored
    #  in another element on the website)
    # @param [Object] json JSON object
    # @param [Object] color_table
    # @return [Array<Item>]
    def self.convert_complex_json(json, color_table)
      # Create the array with all items
      items = Array.new

      # First, we collect all colors and sizes
      colors = []
      sizes = []

      for color_group in json
        colors << color_table[color_group['ColVarId']]

        for size_variant in color_group['SizeVariants']
          sizes << size_variant['SizeName']
        end
      end


      # Second, generate all possibilities with empty stock
      #  status.
      # When an item is out of stock, the website does not
      #  include it on the array. By looking all colors and sizes
      #  available, we can generate all possible combinations.
      for color in colors.uniq
        for size in sizes.uniq
          items << Item.new(size, color, '', '')
        end
      end


      # Now, fill with the correct values for the products that
      #  are on stock.
      for color_group in json
        color_name = color_table[color_group['ColVarId']]

        for size_variant in color_group['SizeVariants']
          size_name = size_variant['SizeName']
          sell_price = size_variant['ProdSizePrices']['SellPrice']
          availability = size_variant['State']

          # Find item in array and update data
          item = items.select{|i| i.same_as?(Item.new(size_name, color_name)) }.first
          item.price = sell_price
          item.stock = availability
        end
      end

      items
    end

    # Generates a string table with all items, listing
    #  their prices and stock status.
    # It is used on the report to give an overview on which
    #  items are available.
    # @param [Array<Item>] items
    # @return [String]
    def self.convert_items_to_string_rows(items)
      return if items.nil?

      output = Array.new

      # Group items by color
      groups = items.group_by{ |item| item.color }

      groups.each do |color, items|
        # Line header. Just to format it better
        output << "#{color.center(15)}  =================================="

        items.each do |item|
          output << "#{item.color.center(15)} / #{item.size.center(10)} / #{item.price.center(10)} / #{item.stock.center(10)}"
        end
      end
      
      output.sort.join('<br/>')
    end
  end
 end