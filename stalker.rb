require 'sinatra'
require 'sinatra/activerecord'
require 'yaml'

require './config/env'

require './models'

require './lib/instagram_stalker'
require './lib/twitter_stalker'
require './lib/facebook_stalker'

enable :sessions

get '/' do
  @last = Blip.order(when: :desc).first
  
  erb :index
end