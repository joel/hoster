require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'json'
require 'naught'

require_relative 'lib/host'

begin
  require 'pry'
rescue LoadError
end

class HostApp < Sinatra::Application

  post '/' do
    content_type :json

    # return if params[:token] != ENV['SLACK_TOKEN']

    text = params[:text]
    text ||= Naught.build { |config| config.black_hole }.new

    if text == 'list'
      return { text: Host.new.list }.to_json
    end

    { text: Host.new.new_host(text) }.to_json
  end
end
