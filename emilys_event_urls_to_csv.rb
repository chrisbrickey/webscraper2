#I used this program to help confirm the similarity of individual event urls for Emilys list,
#...but in early May, the website setup changed and this no longer pulls event data

require 'nokogiri'
require 'open-uri'
require 'csv'


# EMILYS LIST EVENT 1
data_from_event_url1 = Nokogiri::HTML(open("https://secure.emilyslist.org/Chicago_YP17"))  #only 1 upcoming event
parsed_from_url1 = data_from_event_url1.css("section")

CSV.open('raw_data/event1_raw.csv', 'w') do |csv|
  csv << parsed_from_url1
end


# EMILYS LIST EVENT 2 (confirmed that html is in same format as event 1...upcoming events)
data_from_event_url2 = Nokogiri::HTML(open("https://www.flickr.com/photos/emilyslist/albums/72157680519659093"))  #all other events are in the past and stored at flickr
parsed_from_url2 = data_from_event_url1.css("section")


CSV.open('raw_data/event2_raw.csv', 'w') do |csv|
  csv << parsed_from_url2
end
