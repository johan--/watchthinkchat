class Rest
  def self.post(url, payload = {})
    puts "Rest post #{escape(url)}"
    puts "Rest payload #{payload}"
    JSON.parse(RestClient.post(escape(url), payload.to_json, {:content_type => :json, :accept => :json}))
  end

  def self.get(url)
    puts "Rest get #{escape(url)}"
    JSON.parse(RestClient.get(escape(url), {:accept => :json}))
  end

  def self.escape(url)
    url.gsub(' ', '%20')
  end
end
