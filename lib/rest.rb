class Rest
  def self.post(url)
    puts "Rest post #{url}"
    JSON.parse(RestClient.post(url, {:accept => :json}))
  end
  def self.get(url)
    puts "Rest get #{url}"
    JSON.parse(RestClient.get(url, {:accept => :json}))
  end
end
