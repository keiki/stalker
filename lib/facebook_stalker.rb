require 'koala'
require 'geocoder'

class FacebookKey < ActiveRecord::Base
end

module FacebookStalker
  def self.start(appid, appsecret)
    @@appid = appid
    @@appsecret = appsecret
    
    @@token = FacebookKey.last.key rescue nil
    
    @@graph = Koala::Facebook::API.new(@token)
  end
  
  def self.authenticate
    @@oauth = Koala::Facebook::OAuth.new(@@appid, @@appsecret)
    @@token = @@oauth.exchange_access_token_info(@@token)["access_token"]
    
    FacebookKey.create(:key => @@token)
    
    @@graph = Koala::Facebook::API.new(@@token)
  end
  
  def self.list
    if @@graph
      begin
        @@graph.get_connections("me", "posts")
      rescue Koala::Facebook::AuthenticationError
        self.authenticate
        
        retry
      end
    else
      []
    end
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