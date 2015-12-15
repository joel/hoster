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

require_relative 'core_ext/object'
require_relative 'lib/redis_proxy'

begin
  require 'pry'
rescue LoadError
end

class HostApp < Sinatra::Application

  get '/' do
    # return if params[:token] != ENV['SLACK_TOKEN']

    private_message, public_message = '', ''
    params[:text] ||= ''

    begin
      action, option = get_command(params[:text])

      redis_proxy = RedisProxy.new(option == 'dry')

      private_message, public_message = case action.to_sym
      when :list
        ["List :: #{redis_proxy.list.sort.join(', ')}", nil]
      when :help
        [help_message, nil]
      when :reset
        ['RESET, white list was cleaned!', nil]
      when :left
        ["Leftovers => #{redis_proxy.white_list.sort.join(', ')}", nil]
      when :get
        msg = "**#{redis_proxy.get}** will host the next meeting"
        ["Leftovers => #{redis_proxy.white_list.sort.join(', ')}", msg]
      else
      end

      poster = Slack::Poster.new(ENV['SLACK_WEBHOOK_URL'])
      poster.channel = "##{params[:channel_name]}"
      poster.send_message(public_message)

    rescue ArgumentError => e
      private_message = "#{e.message}\n"
      private_message << "\n"
      private_message << help_message
    end

    status 200
    private_message
  end

  private

  def get_command(input)
    commands = input.split
    unless commands.size >= 1 or commands.size <= 2
      raise ArgumentError.new('wrong number of argument')
    end
    action, option = commands
    raise ArgumentError.new("unknow action => '#{action}'") unless ACTIONS.include?(action)
    [action, option]
  end

  def help_message
    msg = "HELP:\n"
    msg << "/meeting help\n"
    msg << "/meeting get dry\n"
    msg << "/meeting list\n"
    msg << "/meeting reset\n"
    msg << "/meeting left\n"
    msg
  end

  ACTIONS = %w(help get list reset left).freeze
end
