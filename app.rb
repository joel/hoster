require 'sinatra'
# require 'json'

begin
  require 'pry'
rescue LoadError
end

class Hoster < Sinatra::Application

  HOSTERS = %w(Lukasz AntoineQ Joel Steve Krzysztof Alexandra).freeze

  get '/' do
    if params['text'] && params['text'] == 'list'
      return "List :: #{HOSTERS.join(', ')}"
    end
    
    new_hoster = if params['text'] && HOSTERS.include?(params['text'])
      (HOSTERS - [params['text']]).sample
    else
      HOSTERS.sample
    end

    # content_type :json
    # {
    #   "response_type": "in_channel",
    #   "text": "The new hoster is **#{new_hoster}** Thanks #{params['text']}",
    #   "attachments": [
    #     {
    #       "text":"Wuuu"
    #     }
    #   ]
    # }.to_json

    if params['text']
      "The new hoster is **#{new_hoster}** and thank you _#{params['text']}_"
    else
      "The new hoster is **#{new_hoster}**"
    end
  end

  get '/list' do
    # content_type :json
    # {
    #   "response_type": "in_channel",
    #   "text": "List :: #{HOSTERS.join(', ')}",
    # }.to_json

    "List :: #{HOSTERS.join(', ')}"
  end

end
