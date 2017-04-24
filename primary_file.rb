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
  #if the tag_pattern pulls only one section, this will be like an array with only one item
  #tag_patterns can be specified to pull multiple items (e.g. multiple <p></p> that match the same condition) which result in an array of many items
  parsed_node_set = scraped_object.css(tag_pattern)

  parsed_array = []
  #converts nodeset to array of strings
  parsed_node_set.each do |element|
    parsed_array << element.to_s
  end

  parsed_array
end

#Emily's list full target tag: <article id="content" class="base main-content" role="main">

#The following URLs and tag_patterns work ...
#pulls all event content into one node
one = scrape("http://www.emilyslist.org/pages/entry/events", "article#content")
#pulls all event content into one node
two = scrape("http://www.emilyslist.org/pages/entry/events", "article[class='base main-content']")
#pulls all event content (within p-tags) into multiple nodes, a node for every p-tag
three = scrape("http://www.emilyslist.org/pages/entry/events", "//article//p")
#below code pushes all the code in between article-tags into one element of NodeSet because there is only one article tag set in the URL
four = scrape("http://www.emilyslist.org/pages/entry/events", "//article")
#below code pushes all the code in between p-tags into separate elements of the NodeSet
five = scrape("http://www.emilyslist.org/pages/entry/events", "//p")

# puts one[0]
# puts two[0]
# puts three[0]
# puts four[0]
# puts five[0]


#Next Steps:
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
