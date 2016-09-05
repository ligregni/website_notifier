require 'sendgrid-ruby'

module Sendmail
    def test name
        puts "hello #{name}"
    end

    def send_mail address,from,subject,text
        client = SendGrid::Client.new do |c|
            c.api_key = ENV['WEBNOTIFIER_SENDGRID_KEY']
        end

        mail = SendGrid::Mail.new do |m|
            m.to = address
            m.from = from
            m.subject = subject
            m.text = text
        end

        res = client.send(mail)
        puts "#{res.code} #{res.body}"
    end
end
