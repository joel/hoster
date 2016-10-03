ENV['RACK_ENV'] = 'test'

require 'rubygems'
require 'bundler/setup'
require 'coveralls'

begin
  require 'pry'
rescue LoadError
end

require 'rack'
require 'rspec'
require 'rack/test'

require 'mock_redis'

require_relative '../app/main'

Coveralls.wear!

RSpec.configure do |config|
  config.include Rack::Test::Methods, type: :controller

  config.run_all_when_everything_filtered = true
  config.before { }
  config.after  { }
end

def app
  HostApp
end
