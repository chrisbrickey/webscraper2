# require 'rubygems'
#lets us turn the string into a nokogiri object
# require 'nokogiri'
#lets us use the 'open' method that does all the work of making the HTTP request to get the raw HTML. 'restclient' is an alternative to open-uri
# require 'open-uri'

#lets us pull data from CSV file
require 'csv'


def generate_url_array(url_prefix, csv_source)

  url_array = []

  CSV.foreach(csv_source) do |row|
    url_string = url_prefix + "#{row[0]}"
    url_array << url_string
  end

  url_array
end

fivecalls_issues_URL_94108 = "https://5calls.org/issues/?address=94108"   #discovered with devtools, XHR filter
fivecalls_issues_URL_prefix = "https://5calls.org/issues/?address="   #discovered with devtools, XHR filter

puts generate_url_array(fivecalls_issues_URL_prefix, "us_postal_codes.csv")
#NEXT STEP: Find live source of up-to-date zipcodes (currently pullig from unofficial 2012 source: https://www.aggdata.com/node/86)
#NEXT STEP: Figure out more efficient way of getting to discrete list of CTAs (lots of overlap among zipcodes)



#Parameters must be in string format e.g. ("http://www.testing123.com", "//outertag//innertag")
def scrape (url_string, tag_pattern)

  #scrapes entire HTML document and places it in a Nokogiri object
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
