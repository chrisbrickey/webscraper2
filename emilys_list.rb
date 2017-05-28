require 'nokogiri' #required by ScrapeEventURLs module
require 'open-uri' #required by ScrapeEventURLs module
require 'json'     #required by CreateJsonObject module
require 'date'     #required by FormatDateTime module
require 'geokit'   #required by DetermineTimezone module
require 'timezone' #required by DetermineTimezone module

require './scrape_event_urls'
include ScrapeEventURLs

require './create_json_object'
include CreateJsonObject

require './format_date_time'
include FormatDateTime

require './determine_timezone'
include DetermineTimezone


#STEP 1: CREATE THE ARRAY OF EVENT-SPECIFIC URLS THAT OCCUR IN THE FUTURE===============================================
def pull_event_urls(main_url, event_url_tag_pattern)
  event_urls = ScrapeEventURLs.create(main_url, event_url_tag_pattern)
  event_urls.select! { |event_url| event_url.include?("flickr") == false } # excludes past events (flicker urls)
end



#STEP 2: PARSE THE DATA FOR A SINGLE URL AND CREATE JSON OBJECT===============================================
def pull_emilys_event_data(event_website) #event_website must be a string

  event_title = ScrapeEventURLs.create(event_website, ".bsd-contribForm-aboveContent/h1")[0][7..-8]

  description_raw, date_location_raw = ScrapeEventURLs.create(event_website, ".bsd-contribForm-aboveContent/p")[0..1]
  description = description_raw.gsub("<p>", "").gsub("</p>", "").gsub("\r", "").gsub("\n", "")

  date_times_raw, location_raw = date_location_raw.split("<br><br>")
  stripped_date_times_raw = date_times_raw.gsub("\n", "").gsub("\r", "").gsub("<p>", "")
  date_raw, both_times = stripped_date_times_raw.split("<br>")
  start_time_raw, end_time_raw = both_times.split(" - ")
  event_location = location_raw.gsub("\r\n", "").gsub("<br>", " ").gsub("</p>", "")


  #This block transforms intermediate date, times, and location into start_time and end_time strings that include date, 24time, and timezone
  date_string = FormatDateTime.date_string(date_raw)
  start_time, end_time = FormatDateTime.time_string(start_time_raw, end_time_raw)
  timezone = "+0000" #using UTC as default for now because DetermineTimezone.zone(event_location) is not yet working
  start_time = "#{date_string} #{start_time} #{timezone}"
  end_time = "#{date_string} #{end_time} #{timezone}"


  #These 2 categories can't yet be determined from url data, so they are given assumptions based on knowledge of Emilys List events in general
  free = false
  cta_type = "onsite"

  parsed_event = CreateJsonObject.create_json_object(event_title, description, free, start_time, end_time, cta_type, event_website)
  [parsed_event, event_location]
end



#STEP 3: PUSHES ALL JSON EVENT OBJECTS AND LOCATION OBJECTS (ONE FROM EACH URL) INTO ARRAYS===============================================
def combine_all_events(url_array)
  events_array = []
  locations_array = []

  url_array.each do |event_url|
    parsed_event, parsed_location = pull_emilys_event_data(event_url)
    events_array << parsed_event
    locations_array << parsed_location
  end

  #this may be changing the JSON objects into strings, need to investigate more
  {events_array: events_array, locations_array: locations_array}
end



if __FILE__ == $PROGRAM_NAME
  emilys_main_URL = "http://www.emilyslist.org/pages/entry/events"
  emilys_event_url_tag_pattern = "//article//p//a/@href"
  emilys_url_array = pull_event_urls(emilys_main_URL, emilys_event_url_tag_pattern)[1..-1] #0th element is NOT an event on Emily's list

  emilys_final_object_all_urls = combine_all_events(emilys_url_array)
  p emilys_final_object_all_urls
end




#See this page for how to assign specific tags based on the URL: http://www.nokogiri.org/tutorials/searching_a_xml_html_document.html
#doc.css('//car:tire', 'car' => 'http://alicesautoparts.com/')
