require 'yaml'

module StockChecker

  # Module for retrieving and storing products in files (YAML format)
  module Storage
    PATH = File.join(File.dirname(__FILE__), '..', '..', 'data')

    # Save product in file
    # @param [Product] product
    def self.store(product)
      Logging::logger.info "[Storage] Storing file #{product.uri}"

      File.open(File.join(PATH, product.uri), 'w') do |file|
        file.write(YAML::dump(product))
      end
    end


    # Retrieve saved file or nil if there is none.
    # Useful to see if this is first time parsing.
    # @param uri
    # @return [Product] product
    def self.retrieve(uri)
      Logging::logger.info "[Storage] Retrieving file #{uri}"

      return nil unless File.exists?(File.join(PATH, uri))

      return YAML::load(File.read(File.join(PATH, uri)))
    end
  end
end