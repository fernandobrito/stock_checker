module StockChecker
  module Importer
    # Imports a CSV file with a url per line
    # @return Array with urls
    def self.import(url)
      HTTParty.get(url).flatten
    end
  end
end