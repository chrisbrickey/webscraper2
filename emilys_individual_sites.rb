require 'nokogiri' #required by ScrapeEventURLs module
require 'open-uri' #required by ScrapeEventURLs module
require 'json'     #required by CreateJsonObject module
require 'date'     #required by CreateDateTimeObject

require './scrape_event_urls'
include ScrapeEventURLs

require './create_json_object'
include CreateJsonObject

# require './create_date_time_object'
# include CreateDateTimeObject


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

  date_times_raw, location_raw = ScrapeEventURLs.create(event_website, ".bsd-contribForm-aboveContent/p")[1].split("<br><br>")

  event_location = location_raw[2..-9].gsub("\r\n", "").gsub("<br>", ", ")

  stripped_date_times_raw = date_times_raw.gsub("\n", "").gsub("\r", "").gsub("<p>", "")
  date_raw, both_times = stripped_date_times_raw.split("<br>")
  start_time_raw, end_time_raw = both_times.split(" - ")


  # start_time, end_time = CreateDateTimeObject.create()

  date_string = Date.parse(date_raw)

  #determines a.m. or p.m. for start_time if isn't already noted
  meridiem = String.new
  unless start_time_raw.chars.any? { |l| ["A", "a", "P", "p"].include?(l) }
    if end_time_raw.chars.any? { |l| ["A", "a"].include?(l) }
      meridiem = "a.m."
    else
      meridiem = "p.m."
    end

    start_time_raw += " #{meridiem}"
  end

  start_time_24hr = DateTime.parse(start_time_raw).strftime("%H:%M")
  end_time_24hr = DateTime.parse(end_time_raw).strftime("%H:%M")

  start_time = "#{date_string} #{start_time_24hr} +0000"
  end_time = "#{date_string} #{end_time_24hr} +0000"

  # event_date = Date.parse event_date   #transforms string to date integer


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
