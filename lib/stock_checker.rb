require File.join(File.dirname(__FILE__), 'helpers', 'timezone')

require File.join(File.dirname(__FILE__), 'stock_checker', 'version')
require File.join(File.dirname(__FILE__), 'stock_checker', 'logging')

require File.join(File.dirname(__FILE__), 'stock_checker', 'comparators', 'comparator')
require File.join(File.dirname(__FILE__), 'stock_checker', 'comparators', 'product_comparator')
require File.join(File.dirname(__FILE__), 'stock_checker', 'comparators', 'stock_comparator')

require File.join(File.dirname(__FILE__), 'stock_checker', 'models', 'product')
require File.join(File.dirname(__FILE__), 'stock_checker', 'models', 'item')
require File.join(File.dirname(__FILE__), 'stock_checker', 'models', 'notification')

require File.join(File.dirname(__FILE__), 'stock_checker', 'report')
require File.join(File.dirname(__FILE__), 'stock_checker', 'parser')
require File.join(File.dirname(__FILE__), 'stock_checker', 'storage')
require File.join(File.dirname(__FILE__), 'stock_checker', 'converter')
require File.join(File.dirname(__FILE__), 'stock_checker', 'importer')
require File.join(File.dirname(__FILE__), 'stock_checker', 'mailer')
require File.join(File.dirname(__FILE__), 'stock_checker', 'batch_comparator')

require File.join(File.dirname(__FILE__), 'helpers', 'try_rescue')

require 'byebug'

module StockChecker
  # @param url String URL of a CSV file with many product URLs
  def self.check_list(options = Hash.new)
    product_urls = StockChecker::Importer.import(options[:url])

    batch_comparator = BatchComparator.new
    batch_comparator.comparators << ProductComparator
    batch_comparator.comparators << StockComparator

    for product_url in product_urls
      StockChecker.check_single(product_url, batch_comparator, options)
    end

    puts batch_comparator.notifications

    if batch_comparator.notifications.any?
      report = Report.new(batch_comparator.notifications)
      report.process

      unless options[:dry_run]
        Mailer.notify_new_report(options[:email], report)
      end
    end
  end

  # @param url String an individual product URL
  def self.check_single(url, batch_comparator, options = Hash.new)
    # Parse from url
    Logging::logger.info '= [StockChecker] Initializing'

    begin
      parser = Parser.new(url)

      new = Product.new(parser.product_name, parser.uri, url)
      new.items = Converter.convert_complex_json(parser.json_variants, parser.colors)
      new.picture_url = parser.picture_url
    rescue IOError
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
