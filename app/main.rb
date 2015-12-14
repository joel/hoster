require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'json'

require_relative 'lib/host'

begin
  require 'pry'
rescue LoadError
end

class HostApp < Sinatra::Application

  post '/' do
    content_type :json

    params['text'] ||= ''

    if params['text'] == 'list'
      return { text: Host.new.list }.to_json
    end

    { text: Host.new.new_host(params['text']) }.to_json
  end
end
