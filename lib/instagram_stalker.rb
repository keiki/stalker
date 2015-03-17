require 'instagram'

module InstagramStalker
  def self.start(id, secret, me)
    Instagram.configure do |config|
      config.client_id = id
      config.client_secret = secret
    end
  
    ME = me
  end
  
  def self.list
    client = Instagram.client(:access_token => ME)
    items = client.user_recent_media
  end
end