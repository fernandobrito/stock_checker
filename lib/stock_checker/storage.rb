module StockChecker
  module Storage
    PATH = File.join(File.dirname(__FILE__), '..', '..', 'data')

    # Save content in file name uri
    #
    # @param [String] uri
    # @param [String] content
    # @return [String] content of file
    def self.store(uri, content)
      Logging::logger.info "[Storage] Storing file #{uri}"

      File.open(File.join(PATH, uri), 'w') do |file|
        file.write(content)
      end
    end


    # Retrieve saved file for this parser or nil if there is none.
    # Useful to see if this is first time parsing.
    #
    # @param uri
    # @return [String] content of file
    def self.retrieve(uri)
      Logging::logger.info "[Storage] Retrieving file #{uri}"

      return nil unless File.exists?(File.join(PATH, uri))

      return File.read(File.join(PATH, uri))
    end
  end
end