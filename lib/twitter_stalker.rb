require 'twitter'
require 'geocoder'

module TwitterStalker
  def self.start(key, secret, accesstoken, accesssecret)
    @@client = Twitter::REST::Client.new do |config|
      config.consumer_key        = key
      config.consumer_secret     = secret
      config.access_token        = accesstoken
      config.access_token_secret = accesssecret
    end
  end
  
  def self.list
    if @@client
      @@client.user_timeline
    else
      []
    end
  end
  
  def self.last_location
    self.list.each do |tweet|
      if tweet.geo? && (lat = tweet.geo.coordinates.first) && (lng = tweet.geo.coordinates.last)
        geo = Geocoder.search([lat, lng].join(',')).first
        
        return {
          when: tweet.created_at,
          city: geo.city,
          state: geo.state,
          country: geo.country,
          continent: nil, #come back to this
          medium: 'twitter'
        }
      end
    end
  end
end