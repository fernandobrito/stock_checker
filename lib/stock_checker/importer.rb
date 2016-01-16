module StockChecker

  # Module to import the file used as input.
  module Importer

    # Imports a CSV file with a url per line
    # @param [String] url input url
    # @return [Array<String>] urls of products
    def self.import(url)
      HTTParty.get(url).flatten
    end
  end
end