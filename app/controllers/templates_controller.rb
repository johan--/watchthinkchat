class TemplatesController < ApplicationController
  before_filter :authenticate_by_facebook!, :if => :is_campaign?

  def template
    if is_campaign?
      redirect_to "/operator/#{current_user.operator_uid}?campaign=#{@campaign.uid}"
    else
      render :template => 'templates/' + params[:path], :layout => !request.xhr?
    end
  end

  protected

  def is_campaign?
    return false unless operator_app?
    @campaign = Campaign.where("uid = ? OR permalink = ?", params[:path], params[:path]).first
    if @campaign
      session[:campaign_id] = @campaign.id
      return true
    end
    return false
  end
end
