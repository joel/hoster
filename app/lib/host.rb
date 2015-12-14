class Host

  HOSTERS = %w(Lukasz AntoineQ Joel Steve Krzysztof Alexandra).freeze

  def new_host(previous_host=nil)
    _previous_host = previous_host
    _previous_host ||= Naught.build do |config|
      config.black_hole
      config.predicates_return false
    end.new

    new_host = HOSTERS.reject { |e| e.downcase == _previous_host.strip.downcase }.sample
    msg = "The new hoster is **#{new_host}**"
    msg << " and thank you _#{_previous_host.strip}_" if _previous_host.present?
    msg
  end

  def list
    "List :: #{HOSTERS.sort.join(', ')}"
  end
end
