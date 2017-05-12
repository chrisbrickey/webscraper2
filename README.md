# webscraper2
This program scrapes and parses URLs, returning a JSON object of event data (e.g. date, location) for input to APIs.  There is a separate file named for each root domain that this program targets.


## Technology
Ruby version 2.4.0p0


## Dependencies
* gem install nokogiri


## Setup
* Run 5calls.org scraper from terminal: `ruby 5calls.rb`
* Run Emily's List individual url scraper from terminal: `ruby emilys_individual_sites.rb` (currently broken due to website changes)
* Run Emily's List main page scraper from terminal: `ruby emilys_main_url_parser.rb` (currently broken due to website changes)
* See reference folder for guidance on nokogiri HTML selectors and zipcode source, among other things


## Upcoming Features
* Confirm that outputs (JSON event objects) can be passed as input to CTA Aggregator API
* Correct parsing issue with Emily's List scrapers caused by recent changes to website
* Correct date issue created by using .to_json (changes integer dates back to strings)
* Streamline process of pulling data from zipcodes - eliminate duplicates from looping through zipcode array and/or use mechanize to pass in forms when required
* Incorporate regular expressions to make parsing less clunky
* Use spooky.js for sites that use Ajax - Nokogiri won't work alone
