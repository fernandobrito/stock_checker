module StockChecker
  module Storage
    PATH = File.join(File.dirname(__FILE__), '..', '..', 'data')

    # * +parser+ - A Parser
    def self.store(parser)
      Logging::logger.info "[Storage] Storing file #{parser.uri}"

      simple_rows = StockChecker::Converter.convert_complex_json(parser.json_variants, parser.colors)

      File.open(File.join(PATH, parser.uri), 'w') do |file|
        file.write(simple_rows)
      end
    end


    # Retrieve saved file for this parser or nil if there is none.
    # Useful to see if this is first time parsing.
    #
    # @param parser
    # @return [String] content of file
    def self.retrieve(parser)
      Logging::logger.info "[Storage] Retrieving file #{parser.uri}"

      return nil unless File.exists?(File.join(PATH, parser.uri))

      return File.read(File.join(PATH, parser.uri))
    end
  end
end