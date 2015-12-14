require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'naught'
require 'slack_poster'

begin
  require 'dotenv'
  Dotenv.load
rescue LoadError
end

require_relative 'lib/host'

begin
  require 'pry'
rescue LoadError
end

class HostApp < Sinatra::Application

  post '/' do
    # return if params[:token] != ENV['SLACK_TOKEN']

    text = params[:text]
    text ||= Naught.build { |config| config.black_hole }.new

    msg = if text == 'list'
      Host.new.list
    else
      Host.new.new_host(text)
    end

    poster = Slack::Poster.new(ENV['SLACK_WEBHOOK_URL'])
    poster.send_message(msg)

    status 200
    'ok'
  end
end
