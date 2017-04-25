# webscraper2
This program defines a method called "scrape" that scrapes a URL and parses by HTML elements (e.g. HTML tag, CSS class, CSS ID). It will eventually return an object of event data.


## Technology
Ruby version 2.4.0p0


## Dependencies
* gem install nokogiri


## Setup
* Run from terminal: `ruby primary_file.rb`
* See reference.txt for guide to selecting HTML elements


## Upcoming Features
* Adjust scrape method to return an object that can be accepted as input by CTA Aggregator API
* Use mechanize to pass in forms when required (e.g. 5calls.org requires zip and issue) to get URL to scrape
* Facilitate scraping of multiple URLs by creating a class Target to store target instances with unique URLs and target_patterns
* Incorporate regular expressions to make parsing less clunky 
* Use spooky.js for sites that use Ajax - Nokogiri won't work alone
