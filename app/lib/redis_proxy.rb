require_relative 'date_helper'

class RedisProxy

  def get(dry)
    setup do
      host = random_host
      add_to_black_list(host) unless dry
      add_to_current_host(host) unless dry
      host
    end
  end

  def who?
    redis.get(CURRENT_HOST) || 'Nobody'
  end

  def add(name, time=T_3_WEEKS) # T_1_WEEK = 604800, T_2_WEEKS = 1209600, T_3_WEEKS = 1814400
    _time = time
    _time ||= T_3_WEEKS

    return unless list.include?(name)
    add_to_black_list(name, _time)
  end

  def list
    setup { redis.smembers(HOSTS_LIST_KEY).sort }
  end

  def reset_black_list
    black_list.each { |host| redis.del("#{BLACK_LIST_KEY}#{host}") }
  end
  alias_method :reset, :reset_black_list

  def white_list
    setup { list - black_list }
  end

  def black_list_with_time
    setup do
      [].tap do |_black_list|
        black_list.each do |host_name|
          _black_list << [host_name, DateHelper.new.distance_of_time_in_words(redis.ttl(key(host_name)))]
        end
      end
    end
  end

  private

  def random_host
    white_list.sample
  end

  HOSTS_LIST_KEY = 'HOST::LIST_KEY'.freeze
  BLACK_LIST_KEY = 'HOST::BLACK_LIST_KEY::'.freeze
  CURRENT_HOST   = 'HOST::CURRENT_HOST'.freeze
  HOST_NAMES     = ENV['HOST_NAMES'].split(',').sort.freeze

  def black_list
    redis.keys.map { |key| redis.get(key) if key.match(/BLACK_LIST_KEY/) }.compact
  end

  def key(name)
    @key ||= {}
    @key[name] ||= "#{BLACK_LIST_KEY}#{name}"
    @key[name]
  end

  def add_to_black_list(host,time=T_3_WEEKS)
    redis.set(key(host), host)
    redis.expire(key(host), time)
    host
  end

  def add_to_current_host(host, time=T_3_WEEKS)
    redis.set(CURRENT_HOST, host)
    redis.expire(CURRENT_HOST, time)
  end

  def setup
    unless redis.exists(RedisProxy::HOSTS_LIST_KEY)
      HOST_NAMES.each { |host| redis.sadd(HOSTS_LIST_KEY, host) }
    end
    yield
  end

  def redis
    @redis ||= begin
      case ENV['RACK_ENV']
      when 'test'
        MockRedis.new
      else
        Redis.new(url: ENV['REDIS_URL'])
      end
    end
  end

end
