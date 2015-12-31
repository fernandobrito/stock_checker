require 'httparty'
require 'nokogiri'

module StockChecker
  class Parser
    include Logging

    attr_reader :url, :colors_element, :parsed_page, :page

    def initialize(url)
      logger.info "[Parser] Parsing #{url}"
      @url = url

      sleep(2)

      @page = HTTParty.get(@url)
      @parsed_page = Nokogiri::HTML(page)

      validate_if_page_exists
    end

    def uri
      Parser.extract_uri(@url)
    end

    # Gets URI and remove any ?colcode=XXXX that may exist
    def self.extract_uri(url)
      url.split('/').last.split('?').first
    end

    def page_exists?
      @page.code != 404
    end

    def json_variants
      JSON.parse(@parsed_page.css("[id$='sAddToBagWrapper']").attr('data-variants'))
    end

    def colors_element
      @parsed_page.css("[id$='colourDdl']").children.to_a.keep_if{|el| el.attr("value")}
    end

    def product_name
      @parsed_page.css("#ProductName").text
    end

    def picture_url
      @parsed_page.css('#zoomtarget').first.attr('href')
    end

    # A hash table with :color_code => color
    def colors
      output = Hash.new

      for element in colors_element
        output[element.attribute("value").text] = element.children.first.text
      end

      output
    end

private
    def validate_if_page_exists
      # Check if product exists. If not, throw exception
      unless page_exists?
        logger.info '[Parser] Page not existent'
        raise IOError, 'Page not existent'
      end
    end
  end
end