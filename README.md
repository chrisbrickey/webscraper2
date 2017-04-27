# webscraper2
This program scrapes HTML and XML from URLs.  It currently parses HTML by HTML elements (e.g. HTML tag, CSS class, CSS ID). It returns parsed event data (e.g. date, location) for input to APIs.


## Technology
Ruby version 2.4.0p0


## Dependencies
* gem install nokogiri


## Setup
* Run from terminal: `ruby primary_file.rb`
* See reference.txt for guide to selecting HTML elements


## Upcoming Features
* Make sure JSON event objects can be passed as input to CTA Aggregator API
* Use mechanize to pass in forms when required (e.g. 5calls.org requires zip to get contact information for CTAs)
* Facilitate scraping of multiple URLs by creating a class Target to store target instances with unique URLs and target_patterns
* Incorporate regular expressions to make parsing less clunky
* Use spooky.js for sites that use Ajax - Nokogiri won't work alone
