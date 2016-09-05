require 'sendmail'
require 'open-uri'
require 'nokogiri'

include Sendmail

class TicketQuery
    def initialize uri, cities, regex
        @uri = uri
        @cities = cities
        @regex = regex
    end

    def get_tickets
        html = Nokogiri::HTML(open(@uri))

        @cities.each do |city|
            xpath = '//div[@id="skills"]//div[@class="col-md-3" ' +
                    'and div/h3="%s"]//a[.="TICKETS"]' % city
            tickets = html.xpath(xpath)
            yield city, @regex.match(tickets.to_s), tickets.to_s
        end
    end
end


plain_site = 'http://ramazzotti.com/it/'
p ARGV
cities = ARGV[0].split(/,[ ]+/).map
#cities = ['MEXICO DC', 'GUADALAJARA', 'ROMA', 'TORONTO']
#cities = ['MEXICO DC', 'GUADALAJARA']

tickets = TicketQuery.new plain_site, cities, /href=\"#\"/

result = Hash.new

tickets.get_tickets do |city, match, ticket|
    result[city] = ticket if not match
end

if result.size > 0
    message = "cities: %s\n\n%s" % [result.keys.join(', '), result.to_s]
    puts message
    Sendmail::send_mail \
        to_address, from_address
        'EROS RAMAZZOTTI TICKETS!!!',message
end

