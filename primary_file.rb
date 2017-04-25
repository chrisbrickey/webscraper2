require 'rubygems'
#lets us turn the string into a nokogiri object
require 'nokogiri'
#lets us use the 'open' method that does all the work of making the HTTP request to get the raw HTML. 'restclient' is an alternative to open-uri
require 'open-uri'

#Parameters must be in string format e.g. ("http://www.testing123.com", "//outertag//innertag")
def scrape (url_string, tag_pattern)

  #scrapes entire HTML document and places it in a Nokogiri object
  scraped_object = Nokogiri::HTML(open(url_string))

  #filters the scraped_object and stores it into a node set
  #if the tag_pattern pulls only one section, this will be an array with only one item
  #tag_patterns can be specified to pull multiple items (e.g. multiple <p></p> that match the same condition) which result in an array of many items
  parsed_node_set = scraped_object.css(tag_pattern)

  parsed_array = []
  #converts nodeset to array of strings
  parsed_node_set.each do |element|
    parsed_array << element.to_s
  end

  parsed_array
end


emilys_URL = "http://www.emilyslist.org/pages/entry/events"
#Emily's list full target tag: <article id="content" class="base main-content" role="main">
  # <p><strong>Wednesday, May 3, 2017<br />
  # Washington, DC</strong><br />
  # <a href="http://www.emilyslist.org/2017">We Are EMILY National Conference &amp;Gala</a></p>


#pulls date and location info into each node
dates_and_locations = scrape(emilys_URL, "//article//p//strong")
#pulls website and event_title into each node AND removes non-event items
websites_and_titles = scrape(emilys_URL, "//article//p//a")[1..-1]

emilys_array = []

dates_and_locations.each_with_index do |combo_string, event_number|
  #use regex instead?
  date_loc_str = combo_string[8..-10]
  event_date, event_location = date_loc_str.split("<br>\n")

  website_title_str = websites_and_titles[event_number][9..-5]
  event_website, event_title = website_title_str.split("\">")

  #These two categories are unknown for Emily's list event URL. This information requires additional logic.
  free = false
  cta_type = "onsite"

  emilys_array << {
    description:  event_title,
    free:         free,
    start_at:     event_date,
    end_at:       event_date,
    cta_type:     cta_type,       #onsite or phone
    website:      event_website,
    #below fields are not specified in CTA aggregator
    temp_ID:      event_number,
    location:     event_location,
    }

end

#values are still in string format
puts emilys_array




#not necessary for Emily's list (all onsite), but may need to use some kind of logic to determine this for other sites
# if event_location.split(" ").length == 0
#   cta_type = phone
# end

#Next Steps:
#Try to pull each event into a node (article/p) FIRST and then use a loop to breakdown each element into four components to avoid data points getting associated with wrong event

#Setup a class for target sites.  Each instance will have a unique URL and tag patterns for event name, contact, date, etc. Then the scrape method can be called on each instance to produce an input to the API.
#An interim step might be to just make a hash that maps URLs to tag_patterns so can loop through multiple tag_patterns for each URL
#e.g. url_map = { "http://www.emilyslist.org/pages/entry/events" => ["//article//p", _____, _____] }

#See this page for how to assign specific tags based on the URL: http://www.nokogiri.org/tutorials/searching_a_xml_html_document.html
#doc.css('//car:tire', 'car' => 'http://alicesautoparts.com/')
