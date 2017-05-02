# webscraper2
This program scrapes and parses URLs, returning a JSON object of event data (e.g. date, location) for input to APIs.  There is a separate file named for each root domain that this program targets.


## Technology
Ruby version 2.4.0p0


## Dependencies
* gem install nokogiri


## Setup
* Run Emily's List scraper from terminal: `ruby emilyslist.rb`
* Run 5calls.org scraper from terminal: `ruby 5calls.rb`
* See reference folder for guidance on nokogiri HTML selectors and zipcode source


## Upcoming Features
* Make sure outputs (JSON event objects) can be passed as input to CTA Aggregator API
* Use mechanize to pass in forms when required
* Incorporate regular expressions to make parsing less clunky
* Use spooky.js for sites that use Ajax - Nokogiri won't work alone
