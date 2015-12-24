require 'mail'
require 'premailer'

module StockChecker
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

    def self.notify_updated_product(to, product_name, body)
      StockChecker::Mailer.send(to, "[Change] #{product_name}", body)
    end

    def self.notify_removed_product(to, product_url)
      StockChecker::Mailer.send(to, "[Removed] #{product_url}", "#{product_url} was removed from the supplier.")
    end

    # The URL dit not exist before and now it does
    def self.notify_readed_product(to, product_name, body)
      StockChecker::Mailer.send(to, "[Readed] #{product_name}", body)
    end


    def self.send(to, subject, body)
      options = EMAIL_OPTIONS

      Mail.defaults do
        delivery_method :smtp, options
      end

      premailer = Premailer.new(body, with_html_string: true)

      # puts premailer.to_inline_css
      # puts body

      mail = Mail.new do
        from     ''
        to       to
        cc       ''
        subject  subject

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