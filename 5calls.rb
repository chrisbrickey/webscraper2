#lets us turn the string into a nokogiri object
require 'nokogiri'
#lets us use the 'open' method that does all the work of making the HTTP request to get the raw HTML. 'restclient' is an alternative to open-uri
require 'open-uri'

#lets us pull data from CSV file
require 'csv'

#both parameters must be in string format
def generate_url_array(url_prefix, csv_source)

  url_array = []

  #NEXT STEP: edit this so can control how many urls to generate at this point (instead of in the subsequent method)
  CSV.foreach(csv_source) do |row|
    url_string = url_prefix + "#{row[0]}"
    url_array << url_string
  end

  url_array[1..-1] #removes first item which was constructed from a header
end


#how_many_zipcodes dictates the number of zipcode URLs that will be scraped
def scrape (url_array, how_many_zipcodes)

  truncated_url_array = url_array[0..(how_many_zipcodes - 1)]

  events_array = []

  truncated_url_array.each do |url|
    #NEXT STEP: find an alternative method for scraping that produces a node set with multiple nodes (instead of everything lumped into one)
    scraped_object = Nokogiri::HTML(open(url))
    parsed_node_set = scraped_object.css("p") #all content is within <p> tags and no CSS styling
    #NEXT STEP: loop through each node (because multiple events within each node)
    #NEXT STEP: create JSON object for each event
    events_array << parsed_node_set
  end

  events_array
end


fivecalls_issues_URL_prefix = "https://5calls.org/issues/?address="  #discovered with devtools, XHR filter
fivecalls_url_array = generate_url_array("https://5calls.org/issues/?address=", "reference/us_postal_codes.csv")
#NEXT STEP: Find live source of up-to-date zipcodes (currently pullig from unofficial 2012 source: https://www.aggdata.com/node/86)
#NEXT STEP: Figure out more efficient way of getting to discrete list of CTAs (lots of overlap among zipcodes)

puts scrape(fivecalls_url_array, 1)
