class SiteController < ApplicationController
  def index
    load_campaign
    return render 'no_campaign' if @campaign.nil?
  end

  protected

  def load_campaign
    url = request.host
    url.slice! ".#{ENV['base_url']}" if request.host.include? ENV['base_url']
    @campaign = Campaign.opened.find_by(url: url)
  end
end
