# webscraper2
This program defines a method called "scrape" that scrapes a URL and parses by HTML element tags. I endeavor to make it parse by CSS class name.


## Technology
Ruby version 2.4.0p0


## Dependencies
* gem install nokogiri


## Setup
* Run from terminal: `ruby primary_file.rb`


## Upcoming Features
* Parse by CSS class
* While loop to iterate through multiple sites
* Use spooky.js for sites that use Ajax - Nokogiri won't work alone
* What about sites that require authentication (username/password)? Use Mechanize to fill out forms? Compliance issues?
