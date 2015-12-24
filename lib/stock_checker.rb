require File.join(File.dirname(__FILE__), 'stock_checker', 'version')
require File.join(File.dirname(__FILE__), 'stock_checker', 'logging')

require File.join(File.dirname(__FILE__), 'stock_checker', 'parser')
require File.join(File.dirname(__FILE__), 'stock_checker', 'storage')
require File.join(File.dirname(__FILE__), 'stock_checker', 'converter')
require File.join(File.dirname(__FILE__), 'stock_checker', 'importer')
require File.join(File.dirname(__FILE__), 'stock_checker', 'diff')
require File.join(File.dirname(__FILE__), 'stock_checker', 'mailer')

require File.join(File.dirname(__FILE__), 'helpers', 'try_rescue')

module StockChecker
  # @param url String URL of a CSV file with many product URLs
  def self.check_list(options = Hash.new)
    product_urls = StockChecker::Importer.import(options[:url])

    for product_url in product_urls
      StockChecker.check_single(product_url, options)
    end
  end

  # @param url String an individual product URL
  def self.check_single(url, options = Hash.new)
    # Parse from url
    Logging::logger.info '= [StockChecker] Initializing'

    parser = StockChecker::Parser.new(url)

    begin
      # Store new json
      new = StockChecker::Converter.convert_complex_json(parser.json_variants, parser.colors)
    rescue IOError
      new = ''
    end

    # Check if we already have a file for this parser
    old = StockChecker::Storage.retrieve(parser.uri)

    # If file exists
    if old
      Logging::logger.info '== [BEFORE] =='
      Logging::logger.info "\n" + old

      Logging::logger.info '== [AFTER] =='
      Logging::logger.info "\n" + new

      Logging::logger.info ''

      # It may still be the case that the file is empty, which means the product does not
      # exist in the supplier anymore (but it existed once, since the file is there)

      # Nothing to do here. Includes it did not exist and still does not
      if Diff.is_equal?(old, new)
        Logging::logger.info '== [StockChecker] Product not updated'

      # It did not exist, but now it does
      elsif old.empty? && !new.empty?
        Logging::logger.info '== [StockChecker] Product did not exist, but now it does'

        diff = StockChecker::Diff.diff(old, new)
        diff.insert(0, "Product: #{url} \n\n")

        unless options[:dry_run]
          StockChecker::Mailer.notify_readed_product(options[:email], parser.product_name, diff)
        end

      # Product existed but now it does not
      elsif new.empty?
        Logging::logger.info '== [StockChecker] Product existed, but now it does not'

        unless options[:dry_run]
          StockChecker::Mailer.notify_removed_product(options[:email], url)
        end

      # Product existed and was updated
      elsif Diff.is_different?(old, new)
        Logging::logger.info '== [StockChecker] Product updated'

        diff = StockChecker::Diff.diff(old, new)
        diff.insert(0, "Product: #{url} \n\n")

        unless options[:dry_run]
          StockChecker::Mailer.notify_updated_product(options[:email], parser.product_name, diff)
        end
      end
    end

    # Save it anyway
    unless options[:dry_run]
      storage = StockChecker::Storage.store(parser.uri, new)
    end

    Logging::logger.info "\n"
  end
end
