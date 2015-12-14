class Host

  HOSTERS = %w(Lukasz AntoineQ Joel Steve Krzysztof Alexandra).freeze

  def new_host(previous_host=nil)
    new_host = random_guess(previous_host)
    msg = "The new hoster is **#{new_host}**"
    msg << " and thank you _#{previous_host.strip}_" if previous_host
    msg
  end

  def list
    "List :: #{HOSTERS.sort.join(', ')}"
  end

  private

  def random_guess(previous_host)
    _previous_host ||= Naught.build { |config| config.black_hole }.new
    excluded = []
    if HOSTERS.map(&:downcase).include?(_previous_host.strip.downcase)
      excluded << _previous_host
    end
    (HOSTERS - [excluded]).sample
  end
end
