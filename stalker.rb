require 'sinatra'
require 'sinatra/activerecord'
require 'yaml'

require './config/env'

require './models'

require './lib/instagram_stalker'
require './lib/twitter_stalker'
require './lib/facebook_stalker'

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
      appid: t['appid'],
      secret: t['appsecret'],
      accesstoken: t['accesstoken'],
      accesssecret: t['accesssecret']
    }
  end
  
  if fb = auth['facebook']
    facebook = {
      token: fb['token']
    }
  end
end

instagram[:id] ||= ENV['INSTAGRAM_ID']
instagram[:secret] ||= ENV['INSTAGRAM_SECRET']
instagram[:me] ||= ENV['INSTAGRAM_ME']

twitter[:appid] ||= ENV['TWITTER_APPID']
twitter[:secret] ||= ENV['TWITTER_SECRET']
twitter[:accesstoken] ||= ENV['TWTTER_ACCESSTOKEN']
twitter[:accesssecret] ||= ENV['TWITTER_ACCESSSECRET']

facebook[:token] ||= ENV['FACEBOOK_TOKEN']

INSTAGRAM = instagram
FACEBOOK = facebook
TWITTER = twitter

InstagramStalker.start(INSTAGRAM[:id], INSTAGRAM[:secret], INSTAGRAM[:me]) #this looks silly. why did I make this a hash. welp, at least it's verbose.
TwitterStalker.start(TWITTER[:appid], TWITTER[:secret], TWITTER[:accesstoken], TWITTER[:accesssecret])
FacebookStalker.start(FACEBOOK[:token])

get '/' do
  @last = Blip.order(when: :desc).first
  
  erb :index
end

get '/stalk' do
  # do all the work; poll once an hour I guess?
  
  ig = InstagramStalker.last_location
  t = TwitterStalker.last_location
  fb = nil
  
  lasts = [ig, t, fb].reject(&:nil?)
  recent = lasts.sort{|x, y| x[:date] <=> y[:date]}.last
  
  last = Blip.order(when: :desc).first
  
  if recent && (!last || (last.when < recent[:when]))
    Blip.create(when: recent[:when], city: recent[:city], state: recent[:state], country: recent[:country], continent: recent[:continent], medium: recent[:medium])
  end
  
  status 200
  body ''
end