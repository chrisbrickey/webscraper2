# webscraper2
This program scrapes a URL and parses by HTML elements (e.g. HTML tag, CSS class, CSS ID). It returns parsed event data (e.g. date, location) for input to APIs.


## Technology
Ruby version 2.4.0p0


## Dependencies
* gem install nokogiri


## Setup
* Run from terminal: `ruby primary_file.rb`
* See reference.txt for guide to selecting HTML elements


## Upcoming Features
* Adapt to scrape XML
* Make sure JSON event objects can be passed as input to CTA Aggregator API
* Use mechanize to pass in forms when required (e.g. 5calls.org requires zip and issue) to get URL to scrape
* Transform start-time and end-time from strings to integers
* Facilitate scraping of multiple URLs by creating a class Target to store target instances with unique URLs and target_patterns
* Incorporate regular expressions to make parsing less clunky
* Use spooky.js for sites that use Ajax - Nokogiri won't work alone
