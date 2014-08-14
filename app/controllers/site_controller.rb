class SiteController < ApplicationController
  def index
    logger.info "Session: #{session.inspect}"
    @campaign = Campaign.where(permalink: 'fallingplates').first
    redirect_to "/c/#{@campaign.uid}" if request.host == ENV['visitor_app_url']
  end
end
