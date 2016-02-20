require 'erb'

module StockChecker

  # Class to generate a HTML report out of a template, using notifications.
  # The reports should be placed in a public WWW folder. The report URL
  #  is going to be sent by email to the user.
  #
  # The name of the report file is made using the current time.
  #
  # The report is only generated after #process is called.
  class Report
    TEMPLATE_FILE = File.join(File.dirname(__FILE__),  '..', '..', 'reports', 'template.html.erb')
    OUTPUT_FOLDER = File.join(File.dirname(__FILE__),  '..', '..', 'reports', 'output')

    URL_PREFIX = ''

    attr_accessor :generated_at, :notifications, :grouped_notifications

    # @param [Array<Notification>] notifications
    def initialize(notifications)
      @notifications = notifications

      # Group notifications by products
      @grouped_notifications = @notifications.group_by(&:product)

      # Sort notifications by priority. To calculate the priority of a
      #  product, all notification's priority are summed.
      # Note that @grouped_notifications is now nested array
      @grouped_notifications = @grouped_notifications.sort_by do |product, notifications|
        notifications.map(&:priority).reduce(:+)
      end.reverse!

      @generated_at = TimeZone.get_cet_time.strftime("%Y-%m-%d %H:%M")
      @output_file_path = File.join(OUTPUT_FOLDER, @generated_at + '.html')
    end

    def report_url
      File.join(URL_PREFIX, File.basename(@output_file_path))
    end

    # For ERB. It exposes the variables on the email template.
    def get_binding
      binding
    end

    # Actually generate the reports, saving it to a file
    # @return [String] file path of the generated report
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