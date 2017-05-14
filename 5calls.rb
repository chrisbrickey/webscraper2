require 'nokogiri'  #lets us turn the string into a nokogiri object
require 'open-uri'  #lets us use the 'open' method that does all the work of making the HTTP request to get the raw HTML. 'restclient' is an alternative to open-uri
require 'csv'       #lets us pull data from CSV file (zip codes are in this format)
require 'json'
require 'pry'

require './scrape_event_urls'
include ScrapeEventURLs

require './create_json_object'
include CreateJsonObject



#========BELOW CODE PULLS 5CALLS DATA FROM ONE ZIP CODE BECAUSE CONTACTS (LOCAL REPS) ARE NOT YET REQUIRED===========

def pull_json_from_url(url, tag_pattern)
  scraped_object = ScrapeEventURLs.scrape(url)    #scraped_object.attribute_nodes => nothing
  parsed_node_set = ScrapeEventURLs.parse_nokogiri_object(scraped_object, tag_pattern)
end


def parse_json(parsed_node_set)
  unparsed_issue_array = JSON.parse(parsed_node_set.text)["issues"]   #if not working try parsed_node_set[0], only one element in the set
  parsed_issue_array = []

  unparsed_issue_array.each do |issue|

    event_title = issue["name"]
    description = issue["reason"]

    #Below categories are not specified in the 5calls data, so I'm setting these as defaults for 5calls CTAs.
    free = true
    event_date = "0000-00-00 00:00:00"      #using Unix time epoch; this represents start_time and end_time
    cta_type = "phone"

    #website depends on users zipcode so for now I'm sending them to main 5calls site which picks up location
    #if we start uploading data across multiple zip codes, this variable should be more specific
    event_website = "https://5calls.org/"
    event_location = "phone_only"

    call_script = issue["script"]   #this is not accepted as-is via postman, open issue


    parsed_issue_array << CreateJsonObject.create_json_object(event_title, description, free, event_date, event_date, cta_type, event_website, event_location, call_script)
  end

  #this is the input to CTA AGGREGATOR - an array of json objects (one per issue)
  parsed_issue_array
end




fivecalls_url_00210 = "https://5calls.org/issues/?address=00210"  #discovered with devtools, XHR filter
fivecalls_tag_pattern = "p"
fivecalls_event_data = pull_json_from_url(fivecalls_url_00210, fivecalls_tag_pattern)
puts parse_json(fivecalls_event_data)













#=========BELOW CODE PULLS 5CALLS DATA ACROSS MULTIPLE ZIP CODES=========
def generate_url_array(url_prefix, csv_source)      #both parameters must be in string format

  url_array = []
  CSV.foreach(csv_source) do |row|          #NEXT STEP: edit this so can control how many urls to generate at this point (instead of in the subsequent method)
    url_string = url_prefix + "#{row[0]}"
    url_array << url_string
  end

  url_array[1..-1] #removes first item which was constructed from a header
end



def scrape_across_zips (url_array, how_many_zipcodes, tag_pattern) #how_many_zipcodes dictates the number of zipcode URLs that will be scraped

  truncated_url_array = url_array[0..(how_many_zipcodes - 1)]
  events_array = []

  truncated_url_array.each do |url|
    scraped_object = ScrapeEventURLs.scrape(url)   #scraped_object.attribute_nodes => nothing
    parsed_node_set = ScrapeEventURLs.parse_nokogiri_object(scraped_object, tag_pattern)     #all content is within <p> tags and no CSS styling, currently only one node

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
fivecalls_tag_pattern = "p"
# puts scrape_across_zips(fivecalls_url_array, 1, "p")    #currently set to 1 zipcode to focus on parsing logic

#NEXT STEP: determine whether or not multiple zipcodes need to be called if we disregard contact info (maybe just use one zipcode)
#NEXT STEP structure zipcodes into arrays by state or region
#NEXT STEP: Find live source of up-to-date zipcodes (currently pullig from unofficial 2012 source: https://www.aggdata.com/node/86)
