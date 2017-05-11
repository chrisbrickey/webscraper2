require 'nokogiri' #required by ScrapeEventURLs module
require 'open-uri' #required by ScrapeEventURLs module
require 'json'     #required by CreateJsonObject module

require './scrape_event_urls'
include ScrapeEventURLs

require './create_json_object'
include CreateJsonObject


#event_url must be a string
def pull_emily_individual_event_data(event_url)
  "placeholder"
  # ScrapeEventURLs.create(event_url, "html") #not working, Emilys list appears to have changed setup
end


def combine_all_events(url_array)
  events_array = []
  url_array.each { |event_url| events_array << pull_emily_individual_event_data(event_url) }
  events_array
end





emilys_main_URL = "http://www.emilyslist.org/pages/entry/events"
emilys_event_urls_tag_pattern = "//article//p//a/@href"

emilys_url_array = ScrapeEventURLs.create(emilys_main_URL, emilys_event_urls_tag_pattern)[1..-1] #0th element is NOT an event on Emily's list
puts emilys_url_array           #array of strings
# puts emilys_url_array.length

emilys_final_object_all_urls = combine_all_events(emilys_url_array)
puts emilys_final_object_all_urls
# puts emilys_final_object_all_urls.length #make sure same as url_array.length



#NEXT STEPS:
#See this page for how to assign specific tags based on the URL: http://www.nokogiri.org/tutorials/searching_a_xml_html_document.html
#doc.css('//car:tire', 'car' => 'http://alicesautoparts.com/')
