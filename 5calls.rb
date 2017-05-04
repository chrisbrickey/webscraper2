#lets us turn the string into a nokogiri object
require 'nokogiri'
#lets us use the 'open' method that does all the work of making the HTTP request to get the raw HTML. 'restclient' is an alternative to open-uri
require 'open-uri'
#lets us pull data from CSV file (zip codes are in this format)
require 'csv'
require 'json'



def generate_url_array(url_prefix, csv_source)      #both parameters must be in string format

  url_array = []
  CSV.foreach(csv_source) do |row|          #NEXT STEP: edit this so can control how many urls to generate at this point (instead of in the subsequent method)
    url_string = url_prefix + "#{row[0]}"
    url_array << url_string
  end

  url_array[1..-1] #removes first item which was constructed from a header
end



def scrape (url_array, how_many_zipcodes) #how_many_zipcodes dictates the number of zipcode URLs that will be scraped

  truncated_url_array = url_array[0..(how_many_zipcodes - 1)]
  events_array = []

  truncated_url_array.each do |url|
    scraped_object = Nokogiri::HTML(open(url))    #scraped_object.attribute_nodes => nothing
    parsed_node_set = scraped_object.css("p")     #all content is within <p> tags and no CSS styling, currently only one node

    #NEXT STEP: PARSE DATA AND CREATE FORMATTED HASH FOR EACH EVENT
    target_element = parsed_node_set[0]   #the class of this single element is "Nokogiri::XML::Element"
                                          # parsed_node_set.attribute("issues") => nothing
                                          # target_element.content => strips the p-tags and returns a giant string that I can't use like a hash; eval(target_element.content) does not work
                                          # target_element.text["issues"] => "issues"; acting like a string, not a hash
                                          # target_element.attribute_nodes => nothing

    events_array << target_element
  end

  events_array
end



fivecalls_issues_URL_prefix = "https://5calls.org/issues/?address="  #discovered with devtools, XHR filter
fivecalls_url_array = generate_url_array(fivecalls_issues_URL_prefix, "reference/us_postal_codes.csv")
puts scrape(fivecalls_url_array, 1)


#NEXT STEP: determine whether or not multiple zipcodes need to be called if we disregard contact info (maybe just use one zipcode)
#NEXT STEP structure zipcodes into arrays by state or region
#NEXT STEP: Find live source of up-to-date zipcodes (currently pullig from unofficial 2012 source: https://www.aggdata.com/node/86)
