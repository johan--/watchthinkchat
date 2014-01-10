source 'https://rubygems.org'
ruby "2.0.0"

# Core
gem 'rails', '4.1.0.beta1'
gem 'rake'
gem 'sprockets-rails', '2.0.0' #  github: "rails/sprockets-rails"
gem 'puma'

# Data Storage
gem 'redis'
gem 'resque'
gem 'pg'
gem 'dalli'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails'

# Authentication
gem 'devise'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'cancan'

# Public API
gem 'MissionHub'
gem 'pusher'
gem 'rest-client'

# Diagnostics
gem 'airbrake'
gem 'newrelic_rpm'
gem 'useragent'

# Assets CSS
gem 'sass-rails'
gem 'anjlab-bootstrap-rails', :require => 'bootstrap-rails', :git => 'https://github.com/anjlab/bootstrap-rails', :branch => '3.0.0'
gem 'font-awesome-rails'
gem 'compass'
gem 'bootstrap-sass', '~> 3.0.3.0'

# Assets Javascript
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'angularjs-rails'
gem 'angular-ui-rails'
gem 'angular-ui-bootstrap-rails'
gem 'therubyracer'

# Assets HTML
gem 'haml'
gem 'formtastic'
gem 'formtastic-bootstrap', :git => 'https://github.com/nickl-/formtastic-bootstrap3'
gem 'tabletastic'
gem 'kaminari'
gem 'paperclip', '~> 3.0'
gem 'polyamorous', github: 'activerecord-hackery/polyamorous'

# Rails Frameworks
gem 'wicked'

# Active Admin
gem 'activeadmin', :git => 'https://github.com/gregbell/active_admin'

# Testing
group :test, :development do
  gem 'minitest'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'factory_girl'
end

group :development do
  gem 'railroady'
  gem 'foreman'
  gem 'rails-footnotes', '>= 3.7.9'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'quiet_assets'
  gem 'seed_dump'
end

group :production do
  gem 'hirefireapp'
  gem 'rails_12factor'
  gem 'rails_serve_static_assets'
end
