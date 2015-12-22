class RedisProxy

  def get(dry)
    setup do
      host = random_host
      add_to_black_list(host) unless dry
      host
    end
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

  private

  def random_host
    list.sample
  end

  HOSTS_LIST_KEY = 'HOST::LIST_KEY'.freeze
  BLACK_LIST_KEY = 'HOST::BLACK_LIST_KEY::'.freeze
  HOST_NAMES = %w(Alexandra AntoineQ Joel Krzysztof Lukasz Steve).sort.freeze

  def black_list
    redis.keys.map { |key| redis.get(key) if key.match(/BLACK_LIST_KEY/) }.compact
  end

  def add_to_black_list(host,time=T_3_WEEKS)
    key = "#{BLACK_LIST_KEY}#{host}"
    redis.set(key, host)
    redis.expire(key, time)
    host
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
