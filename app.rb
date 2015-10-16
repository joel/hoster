require 'sinatra'

class Hoster < Sinatra::Application

  HOSTERS = %w(Lukasz AF AQ Joel Steve Kasia Krzysztof Alexandra)

  get '/' do
    HOSTERS.sample
  end

end
