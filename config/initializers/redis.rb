if ENV['REDISTOGO_URL']
  URI.parse(ENV['REDISTOGO_URL'] || 'redis://localhost:6379')
  REDIS = Redis.new(url: ENV['REDISTOGO_URL'] || 'redis://localhost:6379')
end
