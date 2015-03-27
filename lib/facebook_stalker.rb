require 'koala'
require 'geocoder'

class FacebookKey < ActiveRecord::Base
end

module FacebookStalker
  def self.start(appid, appsecret)
    @appid = appid
    @appsecret = appsecret
    
    @token = FacebookKey.last.key rescue nil
    
    @graph = Koala::Facebook::API.new(@token)
  end
  
  def self.authenticate
    @oauth = Koala::Facebook::OAuth.new(@appid, @appsecret)
    
    begin
      @token = @oauth.exchange_access_token_info(@token)["access_token"]
      
      FacebookKey.destroy_all
    
      FacebookKey.create(key: @token)
    
      @graph = Koala::Facebook::API.new(@token)
    rescue Koala::Facebook::OAuthTokenRequestError
      @graph = nil
    end
  end
  
  def self.list
    listing = []
    
    begin
      if @graph
        listing = @graph.get_connections("me", "posts")
      end
    rescue Koala::Facebook::AuthenticationError => e
      self.authenticate
      
      retry
    end
    
    return listing
  end
  
  def self.last_location
    self.list.each do |post|
      if (loc = post["place"]) && (lat = loc["location"]["latitude"]) && (lng = loc["location"]["longitude"])
        geo = Geocoder.search([lat, lng].join(',')).first
        
        return {
          when: post['created_time'],
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