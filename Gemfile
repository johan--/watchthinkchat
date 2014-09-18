source 'https://rubygems.org'
ruby '2.1.2'

# Core
gem 'rails', '4.1.6'

# Data Storage
gem 'pg'
gem 'dalli'
gem 'connection_pool'
gem 'kgio'

# Authentication
gem 'devise'
gem 'devise_invitable'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'cancancan'
gem 'role_model'

# Public API
gem 'pusher'
gem 'rest-client'

# Assets CSS
gem 'sass-rails', '~> 4.0.3'
gem 'font-awesome-rails'
gem 'bootstrap-sass'

# Assets Javascript
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'angularjs-rails'
gem 'angular-ui-rails'
gem 'angular-ui-bootstrap-rails'
gem 'select2-rails'
gem 'coffee-rails'
gem 'uglifier', '>= 1.3.0'
gem 'lodash-rails'
gem 'rabl'
gem 'oj'

# HTML
gem 'formtastic'
gem 'formtastic-bootstrap'
gem 'tabletastic'
gem 'kaminari', '~> 0.15'
gem 'paperclip'

# Rails Frameworks
gem 'wicked'
gem 'acts_as_list'
gem 'active_type'

# Active Admin
gem 'activeadmin', github: 'gregbell/active_admin'
gem 'ransack'

group :test do
  gem 'database_cleaner'
  gem 'codeclimate-test-reporter', require: nil
  gem 'shoulda-matchers', require: false
  gem 'simplecov'
  gem 'faker'
  gem 'capybara'
  gem 'launchy'
end

group :test, :development do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'assert_difference'
  gem 'byebug'
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-remote'
  gem 'dotenv-rails'
  gem 'fuubar'
  gem 'rubocop'
end

group :development do
  gem 'rails-footnotes', '>= 3.7.9'
  gem 'quiet_assets'
  gem 'guard'
  gem 'guard-rspec', require: false
  gem 'guard-rubocop'
  gem 'guard-rails'
  gem 'guard-bundler'
  gem 'guard-cucumber'
  gem 'guard-puma'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'rb-fsevent', require: false
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :development, :production do
  gem 'puma'
end

group :production do
  gem 'rails_12factor'
  gem 'rails_serve_static_assets'
  gem 'airbrake'
  gem 'newrelic_rpm'
end

