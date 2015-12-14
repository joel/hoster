require 'rubygems'
require 'bundler/setup'

begin
  require 'pry'
rescue LoadError
end

require 'rack'
require 'rspec'
require 'rack/test'
require 'webmock/rspec'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'vcr_cassettes'
  config.hook_into :webmock # or :fakeweb
end

require_relative '../app/main'

RSpec.configure do |config|
  config.include Rack::Test::Methods, type: :controller

  config.run_all_when_everything_filtered = true
  config.before { }
  config.after  { }
end

def app
  HostApp
end
