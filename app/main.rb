require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'naught'
require 'slack_poster'
require 'time_constants'
require 'redis'

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
      action, options = get_command(params[:text])

      redis_proxy = RedisProxy.new

      private_message, public_message = case action.to_sym
      when :list
        ["List :: #{redis_proxy.list.sort.join(', ')}", nil]
      when :blacklist
        if redis_proxy.black_list_with_time.empty?
          ['Nobody was blacklisted', nil]
        else
          msg = "Leftovers:\n"
          redis_proxy.black_list_with_time.each do |host_name, time|
            msg << "#{host_name} => #{time}\n"
          end
          [msg, nil]
        end
      when :help
        [help_message, nil]
      when :reset
        redis_proxy.reset
        ['RESET, white list was cleaned!', nil]
      when :who
        ["Current Host => #{redis_proxy.who?}", nil]
      when :left
        ["Leftovers => #{redis_proxy.white_list.sort.join(', ')}", nil]
      when :get
        dry = options.first
        msg = dry ? '-dry mode-' : ENV['SLACK_MENTIONS']
        msg += " **#{redis_proxy.get(dry)}** will be the chair of the next meeting"
        ["Leftovers => #{redis_proxy.white_list.sort.join(', ')}", msg]
      when :add
        name, time = options
        time = time.to_i if time.present?

        redis_proxy.add(name, time)
        ["**#{name}** was put in blacklist, Leftovers => #{redis_proxy.white_list.sort.join(', ')}", nil]
      end

      if public_message
        poster = Slack::Poster.new(ENV['SLACK_WEBHOOK_URL'])
        poster.channel = ENV['SLACK_CHANNEL_NAME'] # params[:channel_name] ? "#{params[:channel_name]}" : 'backend-team-reloaded'
        poster.send_message(public_message)
      end

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
    action = commands.shift
    options = Array(commands)
    raise ArgumentError.new("unknow action => '#{action}'") unless ACTIONS.include?(action)
    [action, options]
  end

  def help_message
    msg = "HELP:\n"
    msg << "/#{ENV['COMMAND']} help -  give this hepd message\n"
    msg << "/#{ENV['COMMAND']} get - give you the next chair, (dry does no affect anything)\n"
    msg << "/#{ENV['COMMAND']} get dry - give you the next chair, (dry does no affect anything)\n"
    msg << "/#{ENV['COMMAND']} who - give you the current chair\n"
    msg << "/#{ENV['COMMAND']} list - give the enterely list of recorded people\n"
    msg << "/#{ENV['COMMAND']} reset - removing all blacklisted people\n"
    msg << "/#{ENV['COMMAND']} left - who could be the chair\n"
    msg << "/#{ENV['COMMAND']} add - put a person to the blacklist\n"
    msg << "/#{ENV['COMMAND']} add <T_1_WEEK = 604800, T_2_WEEKS = 1209600, T_3_WEEKS = 1814400> - indicate how long a person should stay on the blacklist\n"
    msg << "/#{ENV['COMMAND']} blacklist - get blacklisted people with remain time\n"
    msg
  end

  ACTIONS = %w(help get who list reset left add blacklist).freeze
end
