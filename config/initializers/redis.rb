if ENV['REDISTOGO_URL']
  URI.parse(ENV['REDISTOGO_URL'])
  REDIS = Redis.new(url: ENV['REDISTOGO_URL'])
end
