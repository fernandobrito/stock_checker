require 'mail'
require 'premailer'
require 'erb'

module StockChecker

  # Module to send emails. At the moment, the only report implementation
  #  is a HTML file, whose link is sent by email to the user.
  # Configuration should be moved to a separate file one day.
  module Mailer
    EMAIL_OPTIONS = { :address              => "",
                      :port                 => 587,
                      :domain               => '',
                      :user_name            => '',
                      :password             => '',
                      :authentication       => 'plain',
                      :enable_starttls_auto => true  }

    EMAIL_FROM = ''
    EMAIL_CC = ''

    TEMPLATE_FILE = File.join(File.dirname(__FILE__),  '..', '..', 'reports', 'email_template.html.erb')

    # Notify that a new report is ready.
    # @param [String] to email address to deliver
    # @param [Object] report
    def self.notify_new_report(to, report)
      Mail.defaults do
        delivery_method :smtp, EMAIL_OPTIONS
      end

      # There is a template file for the emails, which uses ERB
      renderer = ERB.new(File.read(TEMPLATE_FILE))
      result = renderer.result(report.get_binding)

      # Emails should use inline CSS for compatibility
      premailer = Premailer.new(result, with_html_string: true)

      mail = Mail.new do
        from     EMAIL_FROM
        to       to
        cc       EMAIL_CC
        subject  'New report is ready'

        html_part do
          content_type 'text/html; charset=UTF-8'
          body premailer.to_inline_css
        end
      end

      if to.nil?
        Logging::logger.info "[WARNING] [Mailer] No email address given. Not sending email."
        return
      end

      Logging::logger.info "[Mailer] Sending email to #{to}"
      mail.deliver!
    end
  end
end