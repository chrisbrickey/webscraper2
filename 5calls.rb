require 'nokogiri'  #lets us turn the string into a nokogiri object
require 'open-uri'  #lets us use the 'open' method that does all the work of making the HTTP request to get the raw HTML. 'restclient' is an alternative to open-uri
require 'csv'       #lets us pull data from CSV file (zip codes are in this format)
require 'json'
require 'pry'

require './scrape_event_urls'
include ScrapeEventURLs

require './create_json_object'
include CreateJsonObject



#========BELOW CODE PULLS 5CALLS DATA FROM ONE ZIP CODE BECAUSE CONTACTS (LOCAL REPS) IS NOT YET REQUIRED===========

def pull_json_from_url(url, tag_pattern)
  scraped_object = ScrapeEventURLs.scrape(url)    #scraped_object.attribute_nodes => nothing
  parsed_node_set = ScrapeEventURLs.parse_nokogiri_object(scraped_object, tag_pattern)
end


fivecalls_url_00210 = "https://5calls.org/issues/?address=00210"  #discovered with devtools, XHR filter
puts pull_json_from_url(fivecalls_url_00210, "p")
puts "\n=================\n"







#=========BELOW CODE PULLS 5CALLS DATA ACROSS MULTIPLE ZIP CODES=========
def generate_url_array(url_prefix, csv_source)      #both parameters must be in string format

  url_array = []
  CSV.foreach(csv_source) do |row|          #NEXT STEP: edit this so can control how many urls to generate at this point (instead of in the subsequent method)
    url_string = url_prefix + "#{row[0]}"
    url_array << url_string
  end

  url_array[1..-1] #removes first item which was constructed from a header
end



def scrape_across_zips (url_array, how_many_zipcodes) #how_many_zipcodes dictates the number of zipcode URLs that will be scraped

  truncated_url_array = url_array[0..(how_many_zipcodes - 1)]
  events_array = []

  truncated_url_array.each do |url|
    scraped_object = Nokogiri::HTML(open(url))    #scraped_object.attribute_nodes => nothing
    parsed_node_set = scraped_object.css("p")     #all content is within <p> tags and no CSS styling, currently only one node

    #NEXT STEP: PARSE DATA AND CREATE FORMATTED HASH FOR EACH EVENT
    # target_element = parsed_node_set      #the class of this single element is "Nokogiri::XML::Element"
                                          # parsed_node_set.attribute("issues") => nothing
                                          # target_element.content => strips the p-tags and returns a giant string that I can't use like a hash; eval(target_element.content) does not work
                                          # target_element.text["issues"] => "issues"; acting like a string, not a hash
                                          # target_element.attribute_nodes => nothing
    # binding.pry
    events_array << parsed_node_set
  end

  events_array
end



fivecalls_url_prefix = "https://5calls.org/issues/?address="  #discovered with devtools, XHR filter
fivecalls_url_array = generate_url_array(fivecalls_url_prefix, "reference/us_postal_codes.csv")

#currently set to 1 to focus on parsing logic which is zip-code-agnostic
puts scrape_across_zips(fivecalls_url_array, 1)

#NEXT STEP: determine whether or not multiple zipcodes need to be called if we disregard contact info (maybe just use one zipcode)
#NEXT STEP structure zipcodes into arrays by state or region
#NEXT STEP: Find live source of up-to-date zipcodes (currently pullig from unofficial 2012 source: https://www.aggdata.com/node/86)
