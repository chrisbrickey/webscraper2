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
date_and_location = scrape(emilys_URL, "//article//p//strong")

#pulls website and event_title into each node (has one extra entry up front and at the end that needs to be removed...not related to events)
site_and_title = scrape(emilys_URL, "//article//p//a")[1..-1]

puts date_and_location
puts "\n"
puts site_and_title

#pulls all event content (within p-tags) into multiple nodes, a node for every p-tag
# scrape(emilys_URL, "//article//p")
# scrape(emilys_URL, "//p")

#pulls all content into one node ...
# scrape(emilys_URL, "article#content")
# scrape(emilys_URL, "article[class='base main-content']")
# scrape(emilys_URL, "//article")

emilys_hash = {
  event_name: 'empty',
  date: 'empty',
  location: 'empty',
  website: 'empty',
}

emilys_hash[:title] = scrape(emilys_URL, "__________")
emilys_hash[:date] = scrape(emilys_URL, "__________")
emilys_hash[:location] = scrape(emilys_URL, "__________")
emilys_hash[:website] = scrape(emilys_URL, "__________")


#Next Steps:
#Adjust method to start by pulling each event into a node (article/p) and then use a loop to breakdown each element into four components

#Setup a class for target sites.  Each instance will have a unique URL and tag patterns for event name, contact, date, etc. Then the scrape method can be called on each instance to produce an input to the API.
#An interim step might be to just make a hash that maps URLs to tag_patterns so can loop through multiple tag_patterns for each URL
#e.g. url_map = { "http://www.emilyslist.org/pages/entry/events" => ["//article//p", _____, _____] }

#See this page for how to assign specific tags based on the URL: http://www.nokogiri.org/tutorials/searching_a_xml_html_document.html
#doc.css('//car:tire', 'car' => 'http://alicesautoparts.com/')


#Additional code that strips tags
#Currently strips length of p-tags on each end; needs to change based on the length of the tag
def stripper(parsed_array)
  parsed_array.map! do |str|
    str[3..-5]
  end
end
