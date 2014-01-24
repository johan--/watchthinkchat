class TemplatesController < ApplicationController
  before_filter :authenticate_by_facebook!, :except => :public_template, :if => Proc.new { |c| request.domain == ENV['operator_app_url'] }

  def index
    if request.domain == ENV['operator_app_url'] && signed_in? && !params[:o].present?
      session[:campaign] ||= params[:path]
      @campaign = Campaign.where("uid = ? OR permalink = ?", session[:campaign], session[:campaign]).first
      logger.info "in templates#index @campaign #{@campaign.inspect}"
      if @campaign.nil?
        session[:campaign] = params[:path]
        redirect_to request.path
        return
      else
        current_user.operator = true
        current_user.operator_uid = current_user.fb_uid
        current_user.save!
      end
      unless current_user.operator_uid.present?
        redirect_to "/", notice: "current user is not an operator or is missing operator_uid"
        return
      end
      redirect_to "/#{@campaign.uid}?o=#{current_user.operator_uid}"
    end
  end

  def public_template
    render :template => 'templates/' + params[:path], :layout => nil
  end

  def template
    render :template => 'templates/' + params[:path], :layout => nil
  end

end
