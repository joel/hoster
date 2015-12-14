require 'rubygems'
require 'bundler/setup'

begin
  require 'pry'
rescue LoadError
end

require 'rack'
require 'rspec'
require 'rack/test'

require_relative '../app/main'

RSpec.configure do |config|
  config.include Rack::Test::Methods, type: :controller

  config.run_all_when_everything_filtered = true
  config.before { }
  config.after  { }
end
#
# def app
#    Rack::Builder.new{
#       run HostApp
#     }.to_app
# end

def app
  # Sinatra::Application
  HostApp
end
