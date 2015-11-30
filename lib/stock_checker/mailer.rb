require 'mail'
require 'premailer'

module StockChecker
  module Mailer
    def self.send(to, subject, body)
      options = { :address              => "***REMOVED***",
                 :port                 => 587,
                 :domain               => 'gmail.com',
                 :user_name            => '***REMOVED***',
                 :password             => '***REMOVED***',
                 :authentication       => 'plain',
                 :enable_starttls_auto => true  }

      Mail.defaults do
        delivery_method :smtp, options
      end

      premailer = Premailer.new(body, with_html_string: true)

      # puts premailer.to_inline_css
      # puts body

      mail = Mail.new do
        from     '***REMOVED***'
        to       to
        subject  subject

        html_part do
          content_type 'text/html; charset=UTF-8'
          body premailer.to_inline_css
        end
      end

      # mail.deliver!
    end
  end
end