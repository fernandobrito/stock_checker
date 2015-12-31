require 'erb'

module StockChecker
  class Report
    TEMPLATE_FILE = File.join(File.dirname(__FILE__),  '..', '..', 'reports', 'template.html.erb')
    OUTPUT_FOLDER = File.join(File.dirname(__FILE__),  '..', '..', 'reports', 'output')

    URL_PREFIX = ''

    attr_accessor :generated_at

    def initialize(notifications)
      @notifications = notifications

      @generated_at = TimeZone.get_cet_time.strftime("%Y-%m-%d %H:%M")
      @output_file_path = File.join(OUTPUT_FOLDER, @generated_at + '.html')
    end

    def report_url
      File.join(URL_PREFIX, File.basename(@output_file_path))
    end

    # For ERB
    def get_binding
      binding
    end

    def process
      renderer = ERB.new(File.read(TEMPLATE_FILE))
      result = renderer.result(binding)

      File.open(@output_file_path, 'w+') do |f|
        f.write(result)
      end

      Logging::logger.info "[Report] Saving report to #{File.basename(@output_file_path)}"

      return @output_file_path
    end
  end
end