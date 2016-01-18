require_relative 'helpers/timezone'
require_relative 'helpers/try_rescue'

require_relative 'stock_checker/version'
require_relative 'stock_checker/logging'

require_relative 'stock_checker/comparators/comparator'
require_relative 'stock_checker/comparators/product_comparator'
require_relative 'stock_checker/comparators/stock_comparator'

require_relative 'stock_checker/models/product'
require_relative 'stock_checker/models/item'
require_relative 'stock_checker/models/notification'

require_relative 'stock_checker/report'
require_relative 'stock_checker/parser'
require_relative 'stock_checker/storage'
require_relative 'stock_checker/converter'
require_relative 'stock_checker/importer'
require_relative 'stock_checker/mailer'
require_relative 'stock_checker/batch_comparator'

# Main module and public interface of this program.
module StockChecker

  # Main public method. Receives a list of product URLs, run
  #  the comparators and generate a report.
  #
  # @param [Hash] options the options to start the program
  # @option options [String] :url URL of a CSV file with many product URLs
  # @option options [String] :email email address to send the notifications to
  # @option options [Boolean] :dry_run do not send emails and do not modify data files
  def self.check_list(options = Hash.new)
    # Get the individual product URLs from the input CSV
    product_urls = Importer.import(options[:url])

    # Select which comparators we want to use
    batch_comparator = BatchComparator.new
    batch_comparator.comparators << ProductComparator
    batch_comparator.comparators << StockComparator

    # Iterate over all product urls and run the comparator
    product_urls.each do |product_url|
      StockChecker.check_single(product_url, batch_comparator, options)
    end

    # If there the Comparators generated any notification,
    #  generate a report and send the URL by email to the user.
    if batch_comparator.notifications.any?
      report = Report.new(batch_comparator.notifications)
      report.process

      unless options[:dry_run]
        Mailer.notify_new_report(options[:email], report)
      end
    end
  end

private
  #
  # @param [String] url an individual product URL
  # @param [BatchComparator] batch_comparator
  # @param [Hash] options
  # @option options [Boolean] :dry_run do not send emails and do not modify data files
  def self.check_single(url, batch_comparator, options = Hash.new)
    Logging::logger.info '= [StockChecker] Initializing'

    begin
      # Parse the product. If a product is not found, an exception is raised.
      parser = Parser.new(url)
      parser.request

      # Saves data parsed in an object
      new = Product.new(parser.product_name, parser.uri, url)
      new.items = Converter.convert_complex_json(parser.json_variants, parser.colors)
      new.picture_url = parser.picture_url
    rescue ProductNotFound
      # Create the object for a product that was not found
      new = Product.new(nil, Parser.extract_uri(url), url)
    end

    # Check if we already have a file for this parser
    old = Storage.retrieve(Parser.extract_uri(url))

    # Compare product
    batch_comparator.compare(old, new) if old

    # Save it anyway
    unless options[:dry_run]
      storage = Storage.store(new)
    end
  end
end
