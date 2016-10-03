source 'https://rubygems.org'
ruby '2.3.1'

gem 'sinatra'
gem 'unicorn'
gem 'naught'

# Slack
gem 'slack-poster'

# Storage
gem 'redis'

# Optimization
gem 'time_constants'

group :development, :test do
  gem 'dotenv'
  gem 'pry'
end

group :test do
  gem 'mock_redis'
  gem 'rack-test'
  gem 'rspec', require: 'spec'
  gem 'coveralls', require: false
end
