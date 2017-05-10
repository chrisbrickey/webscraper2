require 'nokogiri' #also required by ScrapeEventURLs module
require 'open-uri' #also required by ScrapeEventURLs module
require 'json'
require 'csv'
require "./scrape_event_urls.rb"
include ScrapeEventURLs


#create array of event URLs from Emily's list:
main_URL = "http://www.emilyslist.org/pages/entry/events"
event_urls_tag_pattern = "//article//p//a/@href"
emilys_url_array = ScrapeEventURLs.create(main_URL, event_urls_tag_pattern)[1..-1] #0th element is NOT an event
puts emilys_url_array
