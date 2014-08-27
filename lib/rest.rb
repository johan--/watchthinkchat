class Rest
  def self.post(url, payload = {})
    logger.info "Rest post #{escape(url)}"
    logger.info "Rest payload #{payload}"
    r = RestClient.post(escape(url),
                        payload.to_json,
                        content_type: :json, accept: :json)
    logger.info r
    JSON.parse(r)
  end

  def self.get(url)
    logger.info "Rest get #{escape(url)}"
    JSON.parse(RestClient.get(escape(url), accept: :json))
  end

  def self.escape(url)
    url.gsub(' ', '%20')
  end
end
