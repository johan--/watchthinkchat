class Api::CampaignsController < ApplicationController
  #before_filter :ensure_operator_json, :only => :password
  before_filter :authenticate_user!, :only => :password

  def show
    @campaign = Campaign.where(:uid => params[:uid]).first
    if @campaign
      render json: @campaign, status: 201
    else
      render :json => { :error => "No campaign found with that uid" }, :status => 404
    end
  end

  def password
    @campaign = Campaign.where(:uid => params[:uid]).first
    unless @campaign.opened?
      render :json => { :error => "Sorry, campaign is closed" }, :status => 403
      return
    end
    if params[:password].present? && @campaign.try(:password) == params[:password]
      #puts "Api::CampaignsController#password"
      # this is the most secure spot to mark them as an operator
      begin
        current_user.mark_as_operator!(@campaign)
      rescue RestClient::Unauthorized => e
        render :json => { :error => "Invalid missionhub token" }, :status => 500
        return
      end
      render :text => "", status: 201
    elsif @campaign
      render :json => { :error => "Password not valid" }, :status => 401
    else
      render :json => { :error => "No campaign found with that uid" }, :status => 404
    end
  end
end
