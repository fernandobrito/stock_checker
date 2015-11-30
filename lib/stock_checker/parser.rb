require 'httparty'
require 'nokogiri'

module StockChecker
  class Parser
    include Logging

    attr_reader :url, :json_variants, :colors_element, :parsed_page

    def initialize(url)
      logger.info "[Parser] Parsing #{url}"
      @url = url

      sleep(2)
      page = HTTParty.get(@url)
      @parsed_page = Nokogiri::HTML(page)

      @json_variants = JSON.parse(parsed_page.css("[id$='sAddToBagWrapper']").attr('data-variants'))
      @colors_element = parsed_page.css("[id$='colourDdl']").children.to_a.keep_if{|el| el.attr("value")}
    end

    def uri
      # Gets URI and remove any ?colcode=XXXX that may exist
      @url.split('/').last.split('?').first
    end

    def product_name
      @parsed_page.css("#ProductName").text
    end

    # A hash table with :color_code => color
    def colors
      output = Hash.new

      for element in @colors_element
        output[element.attribute("value").text] = element.children.first.text
      end

      output
    end
  end
end