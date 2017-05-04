require 'nokogiri'
require 'open-uri'
require 'json'


#Parameters must be in string format e.g. ("http://www.testing123.com", "//outertag//innertag")
def scrape (url_string, tag_pattern)

  #scrapes entire HTML document and places it in a Nokogiri object (requires 'nokogiri' and 'open-uri')
  scraped_object = Nokogiri::HTML(open(url_string))

  #filters the scraped_object and stores it into a node set
  #tag_patterns are ideally specified to pull multiple items (e.g. multiple <p></p> that match the same condition) which result in an array of many items
  parsed_node_set = scraped_object.css(tag_pattern)

  parsed_array = []
  #converts nodeset to array of strings
  parsed_node_set.each do |element|
    parsed_array << element.to_s
  end

  parsed_array
end


def format(event_title, free, event_date, cta_type, event_website, event_location)

  event_object = {
       "data": {
          "type": "ctas",
          "attributes": {
             "title": event_title,          #String
             "description": "description",  #String (cannot be empty string to create new CTA)
             "free": free,                  #TrueClass
             "start-time": event_date,      #Integer date without time
             "end-time": event_date,        #Integer date without time
             "cta-type": cta_type,          #String ("onsite" or "phone")
             "website": event_website       #String
           },
           "relationships": {
             "location": {
               "data": { "type": "locations", "id": event_location } #String
             },
             "contact": {
               "data": { "type": "contacts", "id": "" }
             },
             "call-script": {
               "data": { "type": "call-scripts", "id": "" }
             }
          }
      }
  }
end


#this is specific to emily's list because of the tags it is directed to pull
def pull_event_data (url_string)
  dates_and_locations = scrape(url_string, "//article//p//strong")  #pulls date and location info into each node
  websites_and_titles = scrape(url_string, "//article//p//a")[1..-1]  #pulls website and event_title into each node AND removes non-event items

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

    #NEXT STEP: Go into each URL and pull additional information, including description


    #These two categories are unknown from Emily's list event URL. This information requires additional logic.
    free = false
    cta_type = "onsite"
    events_array << format(event_title, free, event_date, cta_type, event_website, event_location).to_json
    #NEXT STEP: make sure date maintains integer format when converted to json object

  end

  events_array
end


emilys_URL = "http://www.emilyslist.org/pages/entry/events"
puts pull_event_data(emilys_URL)





#NEXT STEPS:
#Try to pull each event into a node (article/p) FIRST and then use a loop to breakdown each element into four components to avoid data points getting associated with wrong event

#Setup a class for target sites.  Each instance will have a unique URL and tag patterns for event name, contact, date, etc. Then the scrape method can be called on each instance to produce an input to the API.
#An interim step might be to just make a hash that maps URLs to tag_patterns so can loop through multiple tag_patterns for each URL
#e.g. url_map = { "http://www.emilyslist.org/pages/entry/events" => ["//article//p", _____, _____] }

#See this page for how to assign specific tags based on the URL: http://www.nokogiri.org/tutorials/searching_a_xml_html_document.html
#doc.css('//car:tire', 'car' => 'http://alicesautoparts.com/')



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
