class Host

  HOSTERS = %w(Lukasz AntoineQ Joel Steve Krzysztof Alexandra).freeze

  def new_host(previous_host=nil)
    new_host = random_guess(previous_host)
    if previous_host.strip != ''
      "The new hoster is **#{new_host}** and thank you _#{previous_host}_"
    else
      "The new hoster is **#{new_host}**"
    end
  end

  def list
    "List :: #{HOSTERS.sort.join(', ')}"
  end

  private

  def random_guess(previous_host)
    excluded = []
    if previous_host && previous_host.strip != '' && HOSTERS.map(&:downcase).include?(previous_host.strip.downcase)
      excluded << previous_host
    end
    (HOSTERS - [excluded]).sample
  end
end
