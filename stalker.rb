require 'sinatra'
require 'sinatra/activerecord'
require 'yaml'

enable :sessions

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
      appid: t['appid']
      secret: t['appsecret']
      accesstoken: t['accesstoken']
      accesssecret: t'accesssecret']
    }
  end
  
  if auth['facebook']
    
  end
end

instagram[:id] ||= ENV['INSTAGRAM_ID'],
instagram[:secret] ||= ENV['INSTAGRAM_SECRET'],
instagram[:me] ||= ENV['INSTAGRAM_ME']

twitter[:appid] ||= ENV['TWITTER_APPID']
twitter[:secret] ||= ENV['TWITTER_SECRET']
twitter[:accesstoken] ||= ENV['TWTTER_ACCESSTOKEN']
twitter[:accesssecret] ||= ENV['TWITTER_ACCESSSECRET']

INSTAGRAM = instagram
FACEBOOK = facebook
TWITTER = twitter

get '/' do
  ':3'
end

get '/stalk' do
  # do all the work
end

get '/stalk/instagram' do
  
end

get '/stalk/twitter' do
  
end