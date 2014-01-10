class CampaignsController < ApplicationController
  def show
    @campaign = Campaign.where(:permalink => params[:id])
  end
end
