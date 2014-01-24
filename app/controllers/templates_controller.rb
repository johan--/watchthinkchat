class TemplatesController < ApplicationController
  before_filter :authenticate_by_facebook!, :if => :is_campaign?
  
  def index
    if is_campaign?
      redirect_to "/operator/#{current_user.operator_uid}?campaign=#{@campaign.uid}"
    end
  end

  def template
    if is_campaign?
      redirect_to "/operator/#{current_user.operator_uid}?campaign=#{@campaign.uid}"
    else
      render :template => 'templates/' + params[:path], :layout => false
    end
  end

  protected

  def is_campaign?
    return false unless operator_app?
    @campaign = Campaign.where("uid = ? OR permalink = ?", params[:path], params[:path]).first
    if @campaign
      session[:campaign] = @campaign.uid
      return true
    end
    return false
  end
end
