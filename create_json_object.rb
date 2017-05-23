require 'json'

module CreateJsonObject

  def create_json_object(event_title, description, free, start_time, end_time, cta_type, event_website)

    json_event_object = {
         "data": {
            "type": "ctas",
            "attributes": {
               "title": event_title,          #String
               "description": description,    #String (cannot be empty string to create new CTA)
               "free": free,                  #TrueClass
               "start-time": start_time,      #Integer date/time
               "end-time": end_time,          #Integer date/time
               "cta-type": cta_type,          #String ("onsite" or "phone")
               "website": event_website       #String
             },
             #leaving location blank because needs to be added after original CTA is created
             "relationships": {
               "location": {
                 "data": { "type": "locations", "id": "" }
               },
               "contact": {
                 "data": { "type": "contacts", "id": "" }
               },
               #leaving call-script blank because needs to be added after original CTA is created
               "call-script": {
                 "data": { "type": "call-scripts", "id": "" }
               }
            }
        }
    }

    json_event_object.to_json #.to_json is required to get this object to be accepted by CTA aggregator
  end

end#of module
