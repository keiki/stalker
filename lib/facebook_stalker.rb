require 'koala'
require 'geocoder'

module FacebookStalker
  def self.start(token)
    @graph = Koala::Facebook::API.new(token)
  end
  
  attr_reader :graph
  
  def self.list
    @graph.get_connections("me", "feed")
  end
  
  def self.last_location
    self.list.each do |post|
      if (loc = post["place"]) && (lat = loc["location"]["latitude"]) && (loc["location"]["longitude"])
        geo = Geocoder.search([lat, lng].join(',')).first
        
        return {
          when: post.created_time,
          city: geo.city,
          state: geo.state,
          country: geo.country,
          continent: nil, #come back to this
          medium: 'facebook'
        }
      end
    end
  end
end