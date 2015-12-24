# Class to convert the original JSON from the website to a simpler version

# JSON Structure:
# Array with color ColVarId:
#  SizeVariants field with array:
#    SizeName
#    ProdSizePrices
#      SellPrice

module StockChecker
  module Converter
    # Converts an entire hashed json with all products to a simpler hash
    # On the process, replaces color_ids with the color name
    # Then convert it to rows
    def self.convert_complex_json(json, color_table)

      # First, we collect all colors and sizes
      colors = []
      sizes = []

      for color_group in json
        colors << color_table[color_group['ColVarId']]

        for size_variant in color_group['SizeVariants']
          sizes << size_variant['SizeName']
        end
      end


      # Second, generate all possibilities
      hash = Hash.new

      for color in colors
        hash[color] = Hash.new

        for size in sizes
          hash[color][size] = ['', '']
        end
      end


      # Now, fill with the correct values
      for color_group in json
        color_name = color_table[color_group['ColVarId']]

        for size_variant in color_group['SizeVariants']
          size_name = size_variant['SizeName']
          sell_price = size_variant['ProdSizePrices']['SellPrice']
          availability = size_variant['State']

          hash[color_name][size_name] = [sell_price, availability]
        end
      end

      convert_to_rows(hash)
    end


private
    # Converts the object to string
    def self.convert_to_rows(hash)
      output = Array.new

      hash.each do |color, sizes|
        # Line header. Just to format it better
        output << "#{color.center(15)}  =================================="

        sizes.each do |size, items|
          output << "#{color.center(15)} / #{size.center(10)} / #{items[0].center(10)} / #{items[1].center(10)}"
        end
      end

      # puts output.sort.join("\n")
      output.sort.join("\n")
    end
  end
 end