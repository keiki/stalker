ENV['RACK_ENV'] = 'test'

require 'rspec'
require 'rack/test'

require File.expand_path('../stalker', File.dirname(__FILE__))