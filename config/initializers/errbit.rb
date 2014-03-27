Airbrake.configure do |config|
  config.api_key = ENV['errbit_key']
  config.host    = 'errors.uscm.org'
  config.port    = 443
  config.secure  = config.port == 443
end
