class SiteController < ApplicationController
  def index
    logger.info "Session: #{session.inspect}"
    @campaign = Campaign.where(:permalink => "fallingplates").first
    if request.host == ENV['visitor_app_url']
      redirect_to "/c/#{@campaign.uid}"
    end
  end
end
