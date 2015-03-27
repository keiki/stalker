require 'instagram'
require 'geocoder'

module InstagramStalker
  def self.start(id, secret, me)
    Instagram.configure do |config|
      config.client_id = id
      config.client_secret = secret
    end
  
    @client = Instagram.client(:access_token => me)
  end
  
  def self.list
    if @client
      @client.user_recent_media rescue [] #blah blah blah rescue something real
    else
      []
    end
  end
  
  def self.last_location
    self.list.each do |photo|
      if photo.location && (lat = photo.location.latitude) && (lng = photo.location.longitude)
        geo = Geocoder.search([lat, lng].join(',')).first #wishful thinking that first is most relevant?
        
        return {
          when: Time.at(photo.created_time.to_i).to_datetime,
          city: geo.city,
          state: geo.state,
          country: geo.country,
          continent: nil, #come back to this
          medium: 'instagram'
        }
      end
    end
  end
end