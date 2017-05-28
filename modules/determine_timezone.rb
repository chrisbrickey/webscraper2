require 'geokit'
require 'timezone'
require 'active_support/all'
require 'active_support/time'


module DetermineTimezone

  def zone(event_location)

    #this block works
    latitude_longitude_object = Geokit::Geocoders::GoogleGeocoder.geocode(event_location)
    latitude =  latitude_longitude_object.latitude
    longitude =  latitude_longitude_object.longitude


    #the rest of the code does not, need help with API keys
    Timezone::Lookup.config(:geonames) do |c|
      c.username = 'chrisbrickey'
    end

    Timezone::Lookup.config(:google) do |c|
      c.api_key = 'AIzaSyBAmd_Piez-5U1Ta5A2W1qXbifO5KXSjQk'
      # c.client_id = 'your_google_client_id' # if using 'Google for Work'
    end

    timezone = Timezone.lookup(latitude, longitude)
    timezone.to_s
  end

end
