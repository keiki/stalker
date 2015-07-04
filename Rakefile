require './stalker'
require 'sinatra/activerecord/rake'

namespace :db do
  task :load_config do
    require "./stalker"
  end
end

namespace :stalk do
  task :hit do
    #set keys
    auth = YAML.load_file("config/auth.yml") rescue nil

    instagram = {}
    facebook = {}
    twitter = {}

    if auth #this is first because it should only be on my local and blah blah blah
      if ig = auth['instagram']
        instagram = {
          id: ig['id'],
          secret: ig['secret'],
          me: ig['me']
        }
      end #otherwise oops

      if t = auth['twitter']
        twitter = {
          appid: t['appid'],
          secret: t['appsecret'],
          accesstoken: t['accesstoken'],
          accesssecret: t['accesssecret']
        }
      end

      if fb = auth['facebook']
        facebook = {
          appid: fb['appid'],
          appsecret: fb['appsecret']
        }
      end
    end

    instagram[:id] ||= ENV['INSTAGRAM_ID']
    instagram[:secret] ||= ENV['INSTAGRAM_SECRET']
    instagram[:me] ||= ENV['INSTAGRAM_ME']

    twitter[:appid] ||= ENV['TWITTER_APPID']
    twitter[:secret] ||= ENV['TWITTER_APPSECRET']
    twitter[:accesstoken] ||= ENV['TWITTER_ACCESSTOKEN']
    twitter[:accesssecret] ||= ENV['TWITTER_ACCESSSECRET']

    facebook[:appid] ||= ENV['FACEBOOK_APPID']
    facebook[:appsecret] ||= ENV['FACEBOOK_APPSECRET']

    InstagramStalker.start(instagram[:id], instagram[:secret], instagram[:me]) #this looks silly. why did I make this a hash. welp, at least it's verbose.
    TwitterStalker.start(twitter[:appid], twitter[:secret], twitter[:accesstoken], twitter[:accesssecret])
    FacebookStalker.start(facebook[:appid], facebook[:appsecret])
    
    # do all the work; poll once an hour I guess?
    
    puts "polling Instagram"
    ig = InstagramStalker.last_location
    
    puts "polling Twitter"
    t = TwitterStalker.last_location
    
    puts "polling Facebook"
    fb = FacebookStalker.last_location

    lasts = [ig, t, fb].flatten.reject(&:nil?)
    recent = lasts.sort{|x, y| x[:when] <=> y[:when]}.last

    last = Blip.order(when: :desc).first

    if recent && (!last || (last.when < recent[:when]))
      Blip.create(when: recent[:when], city: recent[:city], state: recent[:state], country: recent[:country], continent: recent[:continent], medium: recent[:medium])
    end
  end
end