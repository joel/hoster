require 'sinatra'
require 'json'

begin
  require 'pry'
rescue LoadError
end

class Hoster < Sinatra::Application

  HOSTERS = %w(Lukasz AntoineQ Joel Steve Krzysztof Alexandra).freeze

  post '/' do
    new_hoster = if params['text'] && HOSTERS.include?(params['text'])
      (HOSTERS - [params['text']]).sample
    else
      HOSTERS.sample
    end

    content_type :json
    {
      "response_type": "in_channel",
      "text": "The new hoster is **#{new_hoster}** Thanks #{params['text']}",
      "attachments": [
        {
          "text":"Wuuu"
        }
      ]
    }.to_json
  end

  get '/list' do
    content_type :json
    {
      "response_type": "in_channel",
      "text": "List :: #{HOSTERS.join(', ')}",
    }.to_json
  end

end
