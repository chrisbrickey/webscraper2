require 'nokogiri'
require 'open-uri'

module ScrapeEventURLs

  #scrapes entire HTML document and places it in a Nokogiri object (requires 'nokogiri' and 'open-uri')
  #url_string must be in string format e.g. "http://www.testing123.com"
  def scrape_html (url_string)
    Nokogiri::HTML(open(url_string))
  end


  #filters the scraped_object and stores it into a node set
  #tag_pattern must be in string format e.g. "//outertag//innertag"
  def parse_nokogiri_object(scraped_object, tag_pattern)
    scraped_object.css(tag_pattern)
  end


  #converts nodeset to array of strings
  def populate_array(parsed_node_set)
    str_array = []

    parsed_node_set.each do |element|
      str_array << element.to_s
    end

    str_array
  end

  def create(url_string, tag_pattern)
  # def create_array_of_event_urls(url_string, tag_pattern)
    scraped_object = scrape_html(url_string)
    parsed_node_set = parse_nokogiri_object(scraped_object, tag_pattern)
    populate_array(parsed_node_set)
  end

end#of module
