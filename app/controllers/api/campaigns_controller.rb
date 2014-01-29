class Api::CampaignsController < ApplicationController
  before_filter :ensure_operator_json, :only => :password

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
    if params[:password].present? && @campaign.try(:password) == params[:password]
      render :text => "", status: 201
    elsif @campaign
      render :json => { :error => "Password not valid" }, :status => 401
    else
      render :json => { :error => "No campaign found with that uid" }, :status => 404
    end
  end
end
