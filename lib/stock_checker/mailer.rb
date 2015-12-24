require 'mail'
require 'premailer'

module StockChecker
  module Mailer
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
      options = { :address              => "***REMOVED***",
                 :port                 => 587,
                 :domain               => '***REMOVED***',
                 :user_name            => 'nao.responda@***REMOVED***',
                 :password             => '',
                 :authentication       => 'plain',
                 :enable_starttls_auto => true  }

      Mail.defaults do
        delivery_method :smtp, options
      end

      premailer = Premailer.new(body, with_html_string: true)

      # puts premailer.to_inline_css
      # puts body

      mail = Mail.new do
        from     'nao.responda@***REMOVED***'
        to       to
        cc       'test@***REMOVED***'
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