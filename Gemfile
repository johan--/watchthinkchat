source 'https://rubygems.org'
ruby "2.1.2"

# Core
gem 'rails', '4.1.0.rc1'
gem 'rake'
gem 'sprockets-rails' #  github: "rails/sprockets-rails"
gem 'puma'

# Data Storage
gem 'redis'
gem 'resque'
gem 'pg'
gem 'dalli'
gem 'activerecord-session_store', github: 'rails/activerecord-session_store'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails'

# Authentication
gem "devise", github: "plataformatec/devise"
gem 'omniauth'
gem 'omniauth-facebook'
gem 'cancancan'
gem 'bcrypt', :require => 'bcrypt'
gem 'role_model'

# Public API
gem 'activeresource', require: 'active_resource'
gem 'MissionHub', github: "twinge/missionhub-gem"
gem 'pusher'
gem 'rest-client'

# Diagnostics
gem 'airbrake'
gem 'newrelic_rpm'
gem 'useragent'
gem 'better_errors'
gem 'binding_of_caller'

# Testing

# Assets CSS
gem 'sass-rails', '~> 4.0.3'
gem 'font-awesome-rails'
gem 'bootstrap-sass', '~> 3.1.1.0'

# Assets Javascript
gem 'ngmin-rails'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'angularjs-rails'
gem 'angular-ui-rails'
gem 'angular-ui-bootstrap-rails'
gem 'therubyracer'
gem 'select2-rails'

# Assets HTML
gem 'haml'
gem "formtastic", github: "justinfrench/formtastic"
gem 'formtastic-bootstrap', :git => 'https://github.com/nickl-/formtastic-bootstrap3'
gem 'tabletastic'
gem 'kaminari', '~> 0.15'
gem 'paperclip', '~> 3.0'
gem 'polyamorous', github: 'activerecord-hackery/polyamorous'

# Rails Frameworks
gem 'wicked'
gem 'acts_as_list'
gem 'active_type'

# Active Admin
gem 'activeadmin', github: 'gregbell/active_admin'
gem "ransack", github: "activerecord-hackery/ransack", branch: "rails-4.1"

group :test do
  gem 'database_cleaner'
  gem 'cucumber-rails', :require => false
  gem 'rspec_junit_formatter'
  gem 'faker'
end

group :test, :development do
  gem 'minitest'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'assert_difference'
  gem 'byebug'
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-remote'
  gem 'dotenv-rails'
end

group :development do
  gem 'railroady'
  gem 'foreman'
  gem 'rails-footnotes', '>= 3.7.9'
  gem 'quiet_assets'
  gem 'seed_dump'
  gem 'guard'
  gem 'guard-rspec', require: false
  gem 'guard-rubocop'
  gem 'guard-rails'
  gem 'guard-bundler'
  gem 'guard-cucumber'
  gem 'guard-puma'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'rb-fsevent' if `uname` =~ /Darwin/
  gem 'fuubar'
end

group :production do
  gem 'rails_12factor'
  gem 'rails_serve_static_assets'
end

