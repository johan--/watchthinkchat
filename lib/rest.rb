class Rest
  def self.post(url)
    puts "Rest post #{escape(url)}"
    JSON.parse(RestClient.post(escape(url), {:accept => :json}))
  end
  def self.get(url)
    puts "Rest get #{escape(url)}"
    JSON.parse(RestClient.get(escape(url), {:accept => :json}))
  end

  def self.escape(url)
    url.gsub(' ', '%20')
  end
end
