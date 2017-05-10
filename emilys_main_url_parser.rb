#this program parses only from the main url of emilys list; it is a precursor to the files that scrape individual event URLs
#this program broke in early May 2017 because Emily's list changed their HTML pattern for events on the main page

require 'nokogiri'
require 'open-uri'
require 'json'          #required by CreateJsonObject


require "./scrape_event_urls.rb"
include ScrapeEventURLs

require './create_json_object'
include CreateJsonObject


def pull_emily_main_page_data (url_string, dates_and_location_tag_pattern, websites_and_titles_tag_pattern)
  dates_and_locations = ScrapeEventURLs.create(url_string, dates_and_location_tag_pattern)          #pulls date and location info into each node
  websites_and_titles = ScrapeEventURLs.create(url_string, websites_and_titles_tag_pattern)[1..-1]  #pulls website and event_title into each node AND removes non-event items


  #per JSON API spec, resources must be represented as an array
  events_array = []

  #This loop creates a json object for each event, pulling from both of the parsed arrays created above
  dates_and_locations.each_with_index do |combo_string, event_number|

    #use regex instead?
    date_loc_str = combo_string[8..-10]
    event_date, event_location = date_loc_str.split("<br>\n")
    event_date = Date.parse event_date   #transforms string to date integer

    website_title_str = websites_and_titles[event_number][9..-5]
    event_website, event_title = website_title_str.split("\">")


    #These two categories are unknown from Emily's list event URL. This information requires additional logic.
    description = "description" #can't be an empty string for CTA aggregator
    free = false
    cta_type = "onsite"

    #event_date is used for both start and end  time because no times given
    events_array << CreateJsonObject.create_json_object(event_title, description, free, event_date, event_date, cta_type, event_website, event_location)
  end

  events_array
end




#emilys list parameters for pull from main event page, hard-coded in below method
emilys_URL = "http://www.emilyslist.org/pages/entry/events"
dates_and_location_tag_pattern = "//article//p//strong"
websites_and_titles_tag_pattern = "//article//p//a"


final_object_emilys_main_url = pull_emily_main_page_data(emilys_URL, dates_and_location_tag_pattern, websites_and_titles_tag_pattern)
puts final_object_emilys_main_url





#below is my attempt to isolate the dates AFTER everything is converted to JSON object
#...in hopes of returning the dates to integer format...not yet solved
    # event1 = pull_event_data(emilys_URL)[0]
    # event1_date = JSON.getJSONObject("data").getJSONObject("attributes").getString("end-time")  #computer not recognizing this syntax


#=============================OLD CODE============================
#Emily's list full target tag: <article id="content" class="base main-content" role="main">
  # <p><strong>Wednesday, May 3, 2017<br />
  # Washington, DC</strong><br />
  # <a href="http://www.emilyslist.org/2017">We Are EMILY National Conference &amp;Gala</a></p>


#LOCATION LOGIC: may not be necessary for Emily's list (most onsite), but may need to use some kind of logic to determine this for other sites
  # if event_location.split(" ").length == 0
  #   cta_type = phone
  # end

#SIMPLIFIED OBJECT STRUCTURE
  # json_event_object = {
  #   "title":        event_title,    #String
  #   "description":  "",             #String
  #   "free":         free,           #TrueClass
  #   "start_at":     event_date,     #should be Integer but still String
  #   "end_at":       event_date,     #should be Integer but still String
  #   "cta_type":     cta_type,       #String ("onsite" or "phone")
  #   "website":      event_website,  #String
  #
  #   #below fields are not specified in CTA aggregator
  #   "temp_ID":      event_number,   #Integer
  #   "location":     event_location  #String
  # }


  # def format(event_title, description, free, event_date, cta_type, event_website, event_location)
  #
  #   event_object = {
  #        "data": {
  #           "type": "ctas",
  #           "attributes": {
  #              "title": event_title,          #String
  #              "description": description,  #String (cannot be empty string to create new CTA)
  #              "free": free,                  #TrueClass
  #              "start-time": event_date,      #Integer date without time
  #              "end-time": event_date,        #Integer date without time
  #              "cta-type": cta_type,          #String ("onsite" or "phone")
  #              "website": event_website       #String
  #            },
  #            "relationships": {
  #              "location": {
  #                "data": { "type": "locations", "id": event_location } #String
  #              },
  #              "contact": {
  #                "data": { "type": "contacts", "id": "" }
  #              },
  #              "call-script": {
  #                "data": { "type": "call-scripts", "id": "" }
  #              }
  #           }
  #       }
  #   }
  # end
