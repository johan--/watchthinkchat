class Api::CampaignsController < ApplicationController
  def show
    @campaign = Campaign.where(:permalink => params[:permalink])
    render json: @campaign, status: 201
  end
end
