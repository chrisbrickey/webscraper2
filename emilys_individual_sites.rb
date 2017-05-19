require 'nokogiri' #required by ScrapeEventURLs module
require 'open-uri' #required by ScrapeEventURLs module
require 'json'     #required by CreateJsonObject module

require './scrape_event_urls'
include ScrapeEventURLs

require './create_json_object'
include CreateJsonObject


#STEP 1: CREATES THE ARRAY OF EVENT-SPECIFIC URLS
def pull_event_urls(main_url, event_url_tag_pattern)
  ScrapeEventURLs.create(main_url, event_url_tag_pattern)
end

emilys_main_URL = "http://www.emilyslist.org/pages/entry/events"
emilys_event_url_tag_pattern = "//article//p//a/@href"
emilys_url_array = pull_event_urls(emilys_main_URL, emilys_event_url_tag_pattern)[1..-1] #0th element is NOT an event on Emily's list
# puts emilys_url_array



#STEP 2: PARSE THE DATA FOR A SINGLE URL AND CREATE JSON OBJECT
def pull_emilys_event_data(event_website) #event_website must be a string

  event_title = ScrapeEventURLs.create(event_website, ".bsd-contribForm-aboveContent/h1")[0][7..-8]
  description = "not yet pulled" #can't be an empty string for CTA aggregator
  start_time = "not yet pulled"
  end_time = "not yet pulled"
  event_location = "not yet pulled"

  #These categories can't yet be pulled from the url data, so they are given assumptions based on knowledge of Emilys List events in general
  free = false
  cta_type = "onsite"

  CreateJsonObject.create_json_object(event_title, description, free, start_time, end_time, cta_type, event_website, event_location)

end


#TESTING TAG PATTERNS...the block we want is within "<div class="bsd-contribForm-aboveContent">
# testing_tag_pattern = "div#main-content.full-bleed-bg" #pulls too much, couldn't narrow with h1 or p
# testing_tag_pattern = ".bsd-contribForm-aboveContent/p" #WORKS FOR DATE/TIME/LOCATION

testing_url = emilys_url_array[0] #only upcoming event on main url
puts pull_emilys_event_data(testing_url)



#STEP 3: PUSHES ALL JSON EVENT OBJECTS (ONE FROM EACH URL) INTO AN ARRAY PER JSON API SPEC
def combine_all_events(url_array)
  events_array = []
  url_array.each { |event_url| events_array << pull_emily_individual_event_data(event_url) }
  events_array
end

# emilys_final_object_all_urls = combine_all_events(emilys_url_array)
# puts emilys_final_object_all_urls
# puts emilys_final_object_all_urls.length #make sure same as url_array.length



#NEXT STEPS:
#See this page for how to assign specific tags based on the URL: http://www.nokogiri.org/tutorials/searching_a_xml_html_document.html
#doc.css('//car:tire', 'car' => 'http://alicesautoparts.com/')
