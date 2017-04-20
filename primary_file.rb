#lets us turn the string into a nokogiri object
require 'nokogiri'
require 'open-uri'

scraped_object = Nokogiri::HTML(open("http://www.emilyslist.org/pages/entry/events"))
# puts "scraped_object: #{scraped_object}"

#below code pushes everything in between p-tags (that are also in between article tags) into separate elements of the NodeSet
parsed_node_set = scraped_object.css("//article//p")
# puts "parsed_node_set: #{parsed_node_set}"

puts parsed_node_set[0].to_s
puts "\n"
puts parsed_node_set[1].to_s
puts "\n"
puts parsed_node_set[2].to_s
puts "\n"
puts parsed_node_set[3].to_s


#target tag: <article id="content" class="base main-content" role="main">












#========================OLD CODE =========================
#below code pushes all the code in between article-tags into one element of NodeSet because there is only one article tag set in the URL
# parsed_node_set = scraped_object.css("//article")
#below code pushes all the code in between p-tags into separate elements of the NodeSet
# parsed_node_set = scraped_object.css("//p")
