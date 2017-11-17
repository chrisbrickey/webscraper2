require 'nokogiri'
require 'open-uri'

class EmilysList
  def events
    raw_page = open("http://www.emilyslist.org/pages/entry/events").read
    page = Nokogiri::HTML(raw_page)
    events = []
    page.xpath('//h2[text()="Upcoming Events"]/following-sibling::p').each do |p|
      event = Hash.new

      date_and_location = p.css('strong').first

      next unless date_and_location

      date_loc_parts = date_and_location.text.split("\n")
      event['start_date'] = Date.parse(date_loc_parts[0])
      loc_parts = date_loc_parts[1].split(', ')
      event['location'] = {
        'locality': loc_parts[0],
        'region': loc_parts[1]
      }

      links = p.css('a')
      next unless links.first
      event['title'] = links.first.content
      event_url = p.xpath('./a[1]/@href').first.content
      event['browser_url'] = event_url
      event['identifiers'] = ["emilyslist:#{event_url.split('/').last}"]

      event['origin_system'] = "Emily's List"

      # past events link to flickr sets, not event pages
      if /secure\.emilyslist\.org/ =~ event_url
        events << event
      end
    end
    events
  end
end

scraper = EmilysList.new
events_array = scraper.events
p events_array
#result...
# [{"start_date"=>#<Date: 2017-12-08 ((2458096j,0s,0n),+0s,2299161j)>, 
# "location"=>{:locality=>"Dallas", :region=>"TX "}, 
# "title"=>"Reception", 
# "browser_url"=>"https://secure.emilyslist.org/page/contribute/dallas-2017-regional-reception", 
# "identifiers"=>["emilyslist:dallas-2017-regional-reception"], 
# "origin_system"=>"Emily's List"}]
