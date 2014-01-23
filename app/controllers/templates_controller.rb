class TemplatesController < ApplicationController
  before_filter :authenticate_by_facebook!, :if => Proc.new { |c| request.domain == ENV['operator_app_url'] }

  def index
    logger.info "In TemplatesController request.domain=#{request.domain} ENV['operator_app_url']=#{ENV['operator_app_url']} signed_in?=#{signed_in?} params[:o]=#{params[:o]}"
    if request.domain == ENV['operator_app_url'] && signed_in? && !params[:o].present?
      session[:campaign] ||= params[:path]
      @campaign = Campaign.where("uid = ? OR permalink = ?", session[:campaign], session[:campaign]).first
      if @campaign.nil?
        session[:campaign] = params[:path]
        redirect_to request.path
        return
      else
        user.operator = true
        user.operator_uid = user.fb_uid
        user.save!
      end
      redirect_to "/#{@campaign.uid}?o=#{current_user.uid}"
    end
  end

  def template
    render :template => 'templates/' + params[:path], :layout => nil
  end

end
