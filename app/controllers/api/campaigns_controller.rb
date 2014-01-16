class Api::CampaignsController < ApplicationController
  def show
    @campaign = Campaign.where(:uid => params[:uid]).first
    if @campaign
      render json: @campaign, status: 201
    else
      render :text => "No campaign found with that permalink", :status => '404'
    end
  end
end
