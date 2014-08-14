class TemplatesController < ApplicationController
  before_filter :authenticate_by_facebook!, if: :campaign?

  def index
    redirect_to "/operator/#{current_user.operator_uid}"\
                "?campaign=#{@campaign.uid}" if campaign?
  end

  def template
    return redirect_to "/operator/#{current_user.operator_uid}"\
                  "?campaign=#{@campaign.uid}" if campaign?
    render template: 'templates/' + params[:path], layout: false
  end

  protected

  def campaign?
    return false unless operator_app?
    @campaign = Campaign.where('uid = ? OR permalink = ?',
                               params[:path],
                               params[:path]).first
    if @campaign
      session[:campaign] = @campaign.uid
      return true
    end
    false
  end
end
