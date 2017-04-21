#lets us turn the string into a nokogiri object
require 'nokogiri'
require 'open-uri'

#Parameter requirements:
#url_string must be in string format e.g. "http://www.testing123.com"
#tag_pattern must also be in string format e.g. "//outertag//innertag"
def scrape (url_string, tag_pattern)

  #scrapes entire HTML document and places it in a Nokogiri object
  # scraped_object = Nokogiri::HTML(open("http://www.emilyslist.org/pages/entry/events"))
  scraped_object = Nokogiri::HTML(open(url_string))
  # puts "scraped_object: #{scraped_object}"

  #pushes everything contained in p-tags (if p-tag also contained within article-tag) into separate elements of the NodeSet (enumerable)
      #in the case of Emily's List, p-tags only exist within an article-tag so the //article below is unnecessary
  # parsed_node_set = scraped_object.css("//article//p")
  parsed_node_set = scraped_object.css(tag_pattern)

  parsed_array = []

  #converts nodeset to array of strings
  parsed_node_set.each do |element|
    parsed_array << element.to_s
  end

  # strips the p-tags; may not be necessary
  #!!!This needs to changed based on the length of the tag
  parsed_array.map! do |str|
    str[3..-5]
  end

  parsed_array
end#of scrape method


#Idea: Setup a hash to map URLs to parsing input so can loop through multiple URLs
#e.g. url_map = {"http://www.emilyslist.org/pages/entry/events" => "//article//p"}
#See this page for how to assign specific tags based on the URL: http://www.nokogiri.org/tutorials/searching_a_xml_html_document.html
#doc.css('//car:tire', 'car' => 'http://alicesautoparts.com/')

puts scrape("http://www.emilyslist.org/pages/entry/events", "//article//p")
#Emily's list full target tag: <article id="content" class="base main-content" role="main">



#========================OLD CODE =========================
#below code pushes all the code in between article-tags into one element of NodeSet because there is only one article tag set in the URL
# parsed_node_set = scraped_object.css("//article")
#below code pushes all the code in between p-tags into separate elements of the NodeSet
# parsed_node_set = scraped_object.css("//p")
