require File.join(File.dirname(__FILE__), 'stock_checker', 'version')
require File.join(File.dirname(__FILE__), 'stock_checker', 'logging')

require File.join(File.dirname(__FILE__), 'stock_checker', 'parser')
require File.join(File.dirname(__FILE__), 'stock_checker', 'storage')
require File.join(File.dirname(__FILE__), 'stock_checker', 'converter')
require File.join(File.dirname(__FILE__), 'stock_checker', 'importer')
require File.join(File.dirname(__FILE__), 'stock_checker', 'diff')
require File.join(File.dirname(__FILE__), 'stock_checker', 'mailer')

require 'diffy'

# TODO:
# - Upload to the server and run 6am and 6pm
# - Improve cases when item is out of stock and appears on the list later
# - Check when item is gone. When it is gone, send email. However, continue checking. If it is back, send email
# - ***REMOVED***
# - Fix sorting

module StockChecker
  # @param url String URL of a CSV file with many product URLs
  def self.check_list(url)
    product_urls = StockChecker::Importer.import(url)

    for product_url in product_urls
      StockChecker.check_single(product_url)
    end
  end

  # @param url String an individual product URL
  def self.check_single(url)
    # Parse from url
    Logging::logger.info "= [StockChecker] Initializing"
    parser = StockChecker::Parser.new(url)

    # Store new json
    new = StockChecker::Converter.convert_complex_json(parser.json_variants, parser.colors)

    # Check if we already have a file for this parser
    old = StockChecker::Storage.retrieve(parser)

    if old
      # Compare new JSON with the one saved on the file
      if new != old
        puts "DIFFERENT. Sending email"

        diff = StockChecker::Diff.diff(old, new)
        diff.insert(0, "Product: #{url} \n\n")

        StockChecker::Mailer.send('test@***REMOVED***', "[Change] #{parser.product_name}", diff)
      else
        puts "THE SAME"
      end
    end

    # Save it anyway
    storage = StockChecker::Storage.store(parser)
  end
end
