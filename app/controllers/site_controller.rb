class SiteController < ApplicationController
  before_action :load_campaign
  decorates_assigned :campaign

  def index
    return render 'no_campaign' if @campaign.nil?
  end

  protected

  def load_campaign
    url = request.host
    url.slice! ".#{ENV['base_url']}"
    url.slice! '.lvh.me' if Rails.env.test? # capybara-webkit bug
    @campaign = Campaign.opened.find_by(url: url)
  end
end
