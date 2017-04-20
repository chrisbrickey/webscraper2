# webscraper2
This program scrapes a URL and endeavors to parse by a CSS class name.


## Technology
Ruby version 2.4.0p0


## Dependencies
* gem install nokogiri


## Setup
* Run from terminal: `ruby primary_file.rb`


## Upcoming Features
* While loop to iterate through multiple sites
* Use spooky.js for sites that use Ajax - Nokogiri won't work alone
* What about sites that require authentication (username/password)? Use Mechanize to fill out forms? Compliance issues?
