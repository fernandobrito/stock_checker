require 'httparty'
require 'nokogiri'

module StockChecker
  # Exception for when the product is not found on the website
  class ProductNotFound < Exception ; end

  # Parser for the SportsDirect website. It visits a product's page
  #  and extracts items data (called 'variants'), picture and name
  class Parser
    include Logging

    attr_reader :url, :colors_element, :page, :parsed_page

    # Create the object, but does not parse it yet. The method
    #  #request should be called.
    #
    # @param [String] url of the product
    def initialize(url)
      logger.info "[Parser] Initializing"

      @url = url
    end

    # Parses the URL.
    #
    # @raise [ProductNotFound] if the product does not exist
    def request
      logger.info "[Parser] Parsing #{url}"

      # Politeness 1: sleep between requests
      sleep(1)

      # Makes the request.
      # Politeness 2: identify ourselves as bot so we can be blocked
      @page = HTTParty.get(@url, headers: { 'User-Agent' => 'Mozilla/5.0 (github.com/fernandobrito/stock_checker bot)'})
      @parsed_page = Nokogiri::HTML(page)

      # If all items from the product is out of stock, the
      #  product page is removed.
      validate_if_page_exists
    end

    # Gives a page (HTML string) to the parser. Useful for testing.
    # On real scenarios, user will probably use #request
    # @param [String] page HTML
    def page=(page)
      @page = page
      @parsed_page = Nokogiri::HTML(@page)
    end

    # URI is used to name the file where we store the data of the product
    # @return [String] uri extracted from URL
    def uri
      Parser.extract_uri(@url)
    end

    def json_variants
      JSON.parse(@parsed_page.css("[id$='sAddToBagWrapper']").attr('data-variants'))
    end

    def product_name
      @parsed_page.css("#ProductName").text
    end

    def picture_url
      @parsed_page.css('#zoomtarget').first.attr('href')
    end

    # @return [Hash] a hash table with :color_code => color
    def colors
      output = Hash.new

      for element in colors_element
        output[element.attribute("value").text] = element.children.first.text
      end

      output
    end

    # Gets URI and remove any ?colcode=XXXX that may exist
    def self.extract_uri(url)
      url.split('/').last.split('?').first
    end

  private
    def validate_if_page_exists
      # Check if product exists. If not, throw exception
      unless page_exists?
        logger.info '[Parser] Page not existent'
        raise ProductNotFound.new, 'Page not existent'
      end
    end

    def page_exists?
      @page.code != 404
    end

    def colors_element
      @parsed_page.css("[id$='colourDdl']").children.to_a.keep_if{ |el| el.attr("value") }
    end
  end
end