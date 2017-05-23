# webscraper2
This program scrapes and parses URLs, returning a JSON object of event data (e.g. date, location) for input to APIs.  There is a separate file named for each root domain that this program targets.


## Technology
Ruby version 2.4.0p0


## Dependencies
* gem install nokogiri
* gem install open-uri
* gem install json
* gem install date
* gem install geokit
* gem install timezone


## Setup
* `bundle install`
* Run 5calls.org scraper from terminal: `ruby 5calls.rb`
* Run Emily's List individual url scraper from terminal: `ruby emilys_individual_sites.rb`
* See reference folder for guidance on nokogiri HTML selectors and zipcode source, among other things


## Upcoming Features
* Add method calls to get the scrapers creating and editing CTA calls with a locally running cta-aggregator.  See guidance in "/reference/cta_aggregator_client_REFERENCE" and cta-aggregator-client README
* Streamline process of pulling data from zipcodes - eliminate duplicates from looping through zipcode array and/or use mechanize to pass in forms when required
* Incorporate regular expressions to make parsing less clunky
* Use spooky.js for sites that use Ajax - Nokogiri won't work alone
