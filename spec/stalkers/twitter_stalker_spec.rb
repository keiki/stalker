require File.expand_path('../spec_helper', File.dirname(__FILE__))
require File.expand_path('../../lib/twitter_stalker', File.dirname(__FILE__))

describe TwitterStalker do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
  
  it 'starts' do
    
  end
  
  it 'calls to get lastest posts' do
    
  end
  
  it 'selects latest geotag' do
    
  end
end